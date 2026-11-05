#!/usr/bin/env bash
# Test de concurrence (hors PHPUnit) : 20 encaissements simultanés sur un même
# contrat, plus 10 envois simultanés de la même clé d'idempotence.
# Vérifie : aucun montant perdu, reçus 1..N sans trou ni doublon, une seule
# création pour la clé rejouée (R-33, R-137).
# Prérequis : base "dev" migrée et référentiels chargés.
set -euo pipefail
cd "$(dirname "$0")/../.."
PORT=${PORT:-8765}
URL="http://127.0.0.1:$PORT"

TOKEN=$(php -r '
require "vendor/autoload.php";
(new Symfony\Component\Dotenv\Dotenv())->bootEnv(".env");
$k = new App\Kernel("dev", false); $k->boot(); $c = $k->getContainer();
$em = $c->get("doctrine")->getManager(); $ch = $c->get(App\Securite\Chiffreur::class);
$tel = "+2439".random_int(10000000, 99999999);
$u = new App\Entity\User($tel, $ch->empreinte($tel), "Concurrence", "C".random_int(100000, 999999));
$em->persist($u); $em->flush();
echo $c->get("lexik_jwt_authentication.jwt_manager")->create($u);
')

JOURNAL=$(mktemp)
PHP_CLI_SERVER_WORKERS=8 php -S 127.0.0.1:$PORT -t public >"$JOURNAL" 2>&1 &
SERVEUR=$!
# En cas d'échec, afficher le journal du serveur pour le diagnostic.
diagnostic() {
  echo "--- journal du serveur ---"; tail -50 "$JOURNAL"
  # Sur GitHub Actions, le résumé apparaît aussi en annotation.
  if [ -n "${GITHUB_ACTIONS:-}" ]; then
    echo "::error title=Concurrence::$(tail -15 "$JOURNAL" | tr '\n' ' ' | cut -c1-1500)"
  fi
}
trap 'code=$?; kill $SERVEUR 2>/dev/null; if [ $code -ne 0 ]; then diagnostic; fi' EXIT
for _ in $(seq 1 30); do curl -s -o /dev/null "$URL/api/v1/referentiels/devises" && break; sleep 1; done

H="Authorization: Bearer $TOKEN"; J="Content-Type: application/json"
UNITE=$(curl -sf -H "$H" -H "$J" -d '{"nom":"Concurrence","type":"simple","paysId":1,"categorie":"maison"}' "$URL/api/v1/proprietes" | php -r 'echo json_decode(stream_get_contents(STDIN), true)["unites"][0]["id"];')
CONTRAT=$(curl -sf -H "$H" -H "$J" -d "{\"uniteId\":$UNITE,\"locataireNom\":\"Loc\",\"loyer\":30000,\"devise\":\"USD\",\"dateDebut\":\"$(date +%Y-%m-01)\"}" "$URL/api/v1/contrats" | php -r 'echo json_decode(stream_get_contents(STDIN), true)["id"];')

uuid() { php -r 'require "vendor/autoload.php"; echo Symfony\Component\Uid\Uuid::v4();'; }
MEME=$(uuid)
CODES=$(mktemp)
for _ in $(seq 1 20); do curl -s -o /dev/null -w "%{http_code} " -H "$H" -H "$J" -d "{\"montant\":1000,\"datePaiement\":\"$(date +%F)\",\"cleIdempotence\":\"$(uuid)\"}" "$URL/api/v1/contrats/$CONTRAT/paiements" >>"$CODES" & done
for _ in $(seq 1 10); do curl -s -o /dev/null -w "%{http_code} " -H "$H" -H "$J" -d "{\"montant\":1000,\"datePaiement\":\"$(date +%F)\",\"cleIdempotence\":\"$MEME\"}" "$URL/api/v1/contrats/$CONTRAT/paiements" >>"$CODES" & done
wait $(jobs -p | grep -v "^$SERVEUR$") 2>/dev/null || true
cat "$CODES"; echo
[ -n "${GITHUB_ACTIONS:-}" ] && echo "::notice title=Codes HTTP::$(cat "$CODES")"
sleep 1

php -r '
require "vendor/autoload.php";
(new Symfony\Component\Dotenv\Dotenv())->bootEnv(".env");
$k = new App\Kernel("dev", false); $k->boot();
$db = $k->getContainer()->get("doctrine")->getConnection();
$c = (int) $argv[1];
$p = $db->fetchAssociative("SELECT COUNT(*) n, SUM(montant) total FROM paiement WHERE contrat_id = ?", [$c]);
$r = $db->fetchAssociative("SELECT COUNT(*) n, MIN(sequence) mi, MAX(sequence) ma, COUNT(DISTINCT sequence) d FROM recu r JOIN paiement p ON p.id = r.paiement_id WHERE p.contrat_id = ?", [$c]);
$e = (int) $db->fetchOne("SELECT SUM(montant_paye) FROM echeance WHERE contrat_id = ?", [$c]);
printf("paiements=%d total=%d impute=%d recus=%d sequence=%d..%d distincts=%d\n", $p["n"], $p["total"], $e, $r["n"], $r["mi"], $r["ma"], $r["d"]);
$ok = 21 === (int) $p["n"] && 21000 === (int) $p["total"] && 21000 === $e && 21 === (int) $r["n"] && 1 === (int) $r["mi"] && 21 === (int) $r["ma"] && 21 === (int) $r["d"];
echo $ok ? "OK\n" : "ECHEC\n";
if (!$ok && getenv("GITHUB_ACTIONS")) { printf("::error title=Résultat::paiements=%d total=%d impute=%d recus=%d\n", $p["n"], $p["total"], $e, $r["n"]); }
exit($ok ? 0 : 1);
' "$CONTRAT"
