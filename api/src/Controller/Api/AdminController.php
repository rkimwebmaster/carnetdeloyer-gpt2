<?php

namespace App\Controller\Api;

use App\Api\Dto\Motif;
use App\Api\ErreurMetier;
use App\Api\Presentateur;
use App\Entity\EspaceBailleur;
use App\Entity\JournalAudit;
use App\Entity\PaiementAbonnement;
use App\Entity\User;
use App\Enum\BadgeVerification;
use App\Enum\EspaceWallet;
use App\Enum\StatutPaiementAbonnement;
use App\Service\Abonnements;
use App\Service\Activites;
use App\Service\Parametres;
use App\Service\Wallet;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Opérations d'administration (ROLE_ADMIN), utilisées par le back-office.
 * Chaque action est journalisée (R-115) via le canal "audit".
 */
#[Route('/api/v1/admin')]
final class AdminController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly Abonnements $abonnements,
        private readonly Parametres $parametres,
        private readonly Wallet $wallet,
        private readonly Activites $activites,
        private readonly LoggerInterface $logger,
    ) {
    }

    /** R-111 : file des paiements manuels à valider ou rejeter. */
    #[Route('/paiements-abonnement', methods: ['GET'])]
    public function paiementsAbonnement(Request $request): JsonResponse
    {
        $statut = StatutPaiementAbonnement::tryFrom((string) $request->query->get('statut', 'en_attente')) ?? StatutPaiementAbonnement::EnAttente;
        $qb = $this->em->createQueryBuilder()->select('pa')->from(PaiementAbonnement::class, 'pa')
            ->where('pa.statut = :s')->setParameter('s', $statut)->orderBy('pa.createdAt', 'ASC');

        return $this->page($request, $qb, $this->p->paiementAbonnement(...));
    }

    #[Route('/paiements-abonnement/{id<\d+>}/validation', methods: ['POST'])]
    public function valider(int $id): JsonResponse
    {
        $pa = $this->em->find(PaiementAbonnement::class, $id) ?? throw ErreurMetier::introuvable('Paiement');
        $this->abonnements->valider($pa, $this->moi());
        $this->audit('paiement_abonnement_valide', ['id' => $id]);

        return $this->json($this->p->paiementAbonnement($pa));
    }

    #[Route('/paiements-abonnement/{id<\d+>}/rejet', methods: ['POST'])]
    public function rejeter(int $id, #[MapRequestPayload] Motif $dto): JsonResponse
    {
        $pa = $this->em->find(PaiementAbonnement::class, $id) ?? throw ErreurMetier::introuvable('Paiement');
        $this->abonnements->rejeter($pa, $this->moi(), $dto->motif);
        $this->audit('paiement_abonnement_rejete', ['id' => $id, 'motif' => $dto->motif]);

        return $this->json($this->p->paiementAbonnement($pa));
    }

    /** R-112 : paramètres avec historique. */
    #[Route('/parametres', methods: ['GET'])]
    public function parametres(): JsonResponse
    {
        return $this->json($this->parametres->tous());
    }

    #[Route('/parametres/{cle}', methods: ['PUT'])]
    public function definirParametre(string $cle, Request $request): JsonResponse
    {
        $this->superAdmin();
        $valeur = (string) ($request->toArray()['valeur'] ?? '');
        try {
            $this->parametres->definir($cle, $valeur, $this->moi());
        } catch (\InvalidArgumentException $e) {
            throw ErreurMetier::champ('valeur', 'PARAMETRE_INVALIDE', $e->getMessage());
        }
        $this->em->flush();
        $this->audit('parametre_modifie', ['cle' => $cle, 'valeur' => $valeur]);

        return $this->json($this->parametres->tous());
    }

    /** R-113 : ajustement uniquement par écriture motivée. */
    #[Route('/utilisateurs/{id<\d+>}/wallet/ajustements', methods: ['POST'])]
    public function ajusterWallet(int $id, Request $request): JsonResponse
    {
        $this->superAdmin();
        $user = $this->em->find(User::class, $id) ?? throw ErreurMetier::introuvable('Utilisateur');
        $d = $request->toArray();
        $montant = (int) ($d['montant'] ?? 0);
        $motif = trim((string) ($d['motif'] ?? ''));
        $espace = EspaceWallet::tryFrom((string) ($d['espace'] ?? 'bailleur')) ?? EspaceWallet::Bailleur;
        if (0 === $montant || '' === $motif) {
            throw ErreurMetier::champ('motif', 'AJUSTEMENT_INVALIDE', 'Montant non nul et motif obligatoires.');
        }
        $this->em->wrapInTransaction(function () use ($user, $espace, $montant, $motif): void {
            if ($montant > 0) {
                $this->wallet->crediter($user, $espace, $montant, 'ajustement', null, null, $motif, $this->moi());
            } else {
                $this->wallet->debiter($user, $espace, -$montant, 'ajustement', null, false, $motif, $this->moi());
                $this->em->flush();
            }
        });
        $this->audit('wallet_ajuste', ['user' => $id, 'montant' => $montant, 'motif' => $motif]);

        return $this->json(['total' => $this->wallet->solde($user)]);
    }

    /** R-169 à R-171 : attribution ou retrait du badge. */
    #[Route('/espaces/{id<\d+>}/badge', methods: ['PUT'])]
    public function badge(int $id, Request $request): JsonResponse
    {
        $espace = $this->em->find(EspaceBailleur::class, $id) ?? throw ErreurMetier::introuvable('Espace');
        $d = $request->toArray();
        $badge = null === ($d['badge'] ?? null) ? null : (BadgeVerification::tryFrom((string) $d['badge']) ?? throw ErreurMetier::champ('badge', 'BADGE_INCONNU', 'Badge inconnu.'));
        $expire = isset($d['expireLe']) ? new \DateTimeImmutable((string) $d['expireLe']) : null;
        $espace->attribuerBadge($badge, $this->moi(), $expire);
        if (null !== $badge) {
            $this->activites->enregistrer(Activites::BADGE_OBTENU, $this->moi(), $espace, null, $espace, ['badge' => $badge->value]);
        }
        $this->em->flush();
        $this->audit('badge_modifie', ['espace' => $id, 'badge' => $badge?->value]);

        return $this->json($this->p->espace($espace));
    }

    /** R-110 : recherche de comptes par téléphone (exact) ou nom. */
    #[Route('/utilisateurs', methods: ['GET'])]
    public function utilisateurs(Request $request, \App\Securite\Chiffreur $chiffreur): JsonResponse
    {
        $q = trim((string) $request->query->get('q', ''));
        $qb = $this->em->createQueryBuilder()->select('u')->from(User::class, 'u')->orderBy('u.createdAt', 'DESC');
        if ('' !== $q) {
            $tel = \App\Securite\Telephone::normaliser($q);
            null !== $tel
                ? $qb->where('u.telephoneEmpreinte = :e')->setParameter('e', $chiffreur->empreinte($tel))
                : $qb->where('u.nom LIKE :n')->setParameter('n', '%'.addcslashes($q, '%_').'%');
        }

        return $this->page($request, $qb, fn (User $u) => [
            'id' => $u->getId(), 'nom' => $u->getNom(), 'telephone' => $u->getTelephone(), 'actif' => $u->isActif(),
            'roles' => $u->getRoles(), 'creeLe' => Presentateur::dateHeure($u->getCreatedAt()),
            'wallet' => $this->isGranted('ROLE_SUPER_ADMIN') ? $this->wallet->solde($u) : null,
        ]);
    }

    /** R-110 : suspension (réversible) d'un compte. */
    #[Route('/utilisateurs/{id<\d+>}/suspension', methods: ['PUT'])]
    public function suspendre(int $id, Request $request): JsonResponse
    {
        $user = $this->em->find(User::class, $id) ?? throw ErreurMetier::introuvable('Utilisateur');
        $actif = !(bool) ($request->toArray()['suspendu'] ?? true);
        $user->setActif($actif);
        $this->em->flush();
        $this->audit($actif ? 'compte_reactive' : 'compte_suspendu', ['user' => $id]);

        return $this->json(['id' => $id, 'actif' => $actif]);
    }

    /** R-115 : journal d'audit. */
    #[Route('/audit', methods: ['GET'])]
    public function journal(Request $request): JsonResponse
    {
        $qb = $this->em->createQueryBuilder()->select('j')->from(JournalAudit::class, 'j')->orderBy('j.createdAt', 'DESC')->addOrderBy('j.id', 'DESC');

        return $this->page($request, $qb, static fn (JournalAudit $j) => [
            'id' => $j->getId(), 'admin' => $j->getAdmin()->getNom(), 'action' => $j->getAction(),
            'contexte' => (object) $j->getContexte(), 'le' => Presentateur::dateHeure($j->getCreatedAt()),
        ]);
    }

    /** R-114 : tableau de bord d'exploitation. */
    #[Route('/tableau-de-bord', methods: ['GET'])]
    public function tableauDeBord(\Psr\Clock\ClockInterface $clock): JsonResponse
    {
        $debutMois = $clock->now()->modify('first day of this month')->setTime(0, 0);
        $scalaire = fn (string $dql, array $p = []) => (int) $this->em->createQuery($dql)->setParameters($p)->getSingleScalarResult();

        return $this->json([
            'comptesActifs' => $scalaire('SELECT COUNT(u.id) FROM App\Entity\User u WHERE u.actif = true'),
            'unitesPayantes' => $scalaire("SELECT COUNT(u.id) FROM App\Entity\Unite u WHERE u.abonnementFin > CURRENT_DATE() AND (u.gratuiteJusquAu IS NULL OR u.gratuiteJusquAu < u.abonnementFin)"),
            'chiffreAffairesMoisUsd' => $scalaire("SELECT COALESCE(SUM(p.montantUsd), 0) FROM App\Entity\PaiementAbonnement p WHERE p.statut = 'valide' AND p.createdAt >= :d", ['d' => $debutMois]),
            'paiementsEnAttente' => $scalaire("SELECT COUNT(p.id) FROM App\Entity\PaiementAbonnement p WHERE p.statut = 'en_attente'"),
            'renouvellements30Jours' => $scalaire('SELECT COUNT(u.id) FROM App\Entity\Unite u WHERE u.abonnementFin BETWEEN CURRENT_DATE() AND :f', ['f' => $clock->now()->modify('+30 days')]),
        ]);
    }

    /** R-116 : le support n'a accès ni aux paramètres ni au wallet. */
    private function superAdmin(): void
    {
        if (!$this->isGranted('ROLE_SUPER_ADMIN')) {
            throw ErreurMetier::interdit('Réservé au super-administrateur.');
        }
    }

    /** @param array<string, scalar|null> $contexte */
    private function audit(string $action, array $contexte): void
    {
        $this->em->persist(new JournalAudit($this->moi(), $action, $contexte));
        $this->em->flush();
        $this->logger->notice('[AUDIT] {action} par {admin}', ['action' => $action, 'admin' => $this->moi()->getId()] + $contexte);
    }
}
