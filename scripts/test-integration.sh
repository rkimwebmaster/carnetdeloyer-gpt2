#!/usr/bin/env bash
# Test de contrat de bout en bout : l'app Flutter (services réels) contre l'API
# Symfony réelle sur une base MySQL/MariaDB de test.
set -euo pipefail
RACINE="$(cd "$(dirname "$0")/.." && pwd)"
PORT=${PORT:-8766}
cd "$RACINE/api"

export APP_ENV=test
php bin/console lexik:jwt:generate-keypair --skip-if-exists -q
php bin/console doctrine:database:drop --force --if-exists -q
php bin/console doctrine:database:create -q
php bin/console doctrine:migrations:migrate -n -q
php bin/console app:referentiels:charger -q

read -r JETON JETON_L TEL_L < <(php -r '
require "vendor/autoload.php";
(new Symfony\Component\Dotenv\Dotenv())->bootEnv(".env");
$k = new App\Kernel("test", false); $k->boot(); $c = $k->getContainer();
$em = $c->get("doctrine")->getManager(); $ch = $c->get(App\Securite\Chiffreur::class);
$pays = $em->getRepository(App\Entity\PaysApi::class)->findOneBy(["codeIso" => "CD"]);
$jwt = $c->get("lexik_jwt_authentication.jwt_manager");
$sortie = [];
foreach (["Bailleur intégration", "Locataire intégration"] as $i => $nom) {
    $tel = "+2439".random_int(10000000, 99999999);
    $u = new App\Entity\User($tel, $ch->empreinte($tel), $nom, "I".$i.random_int(10000, 99999));
    $u->setPays($pays); $em->persist($u); $em->flush();
    $sortie[] = $jwt->create($u); $dernierTel = $tel;
}
echo $sortie[0], " ", $sortie[1], " ", $dernierTel, "\n";
')

APP_ENV=test php -d variables_order=EGPCS -S 127.0.0.1:$PORT -t public >/tmp/cdl-integration.log 2>&1 &
SERVEUR=$!
trap 'kill $SERVEUR 2>/dev/null' EXIT
sleep 2

cd "$RACINE/mobile"
CDL_API_URL="http://127.0.0.1:$PORT" CDL_JETON="$JETON" CDL_JETON_LOCATAIRE="$JETON_L" CDL_TEL_LOCATAIRE="$TEL_L" \
  flutter test test/integration --run-skipped --tags integration
