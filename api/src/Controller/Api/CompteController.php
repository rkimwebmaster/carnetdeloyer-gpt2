<?php

namespace App\Controller\Api;

use App\Api\Presentateur;
use App\Entity\Activite;
use App\Entity\Contrat;
use App\Entity\EcritureWallet;
use App\Entity\Echeance;
use App\Entity\Paiement;
use App\Entity\Unite;
use App\Enum\EspaceWallet;
use App\Enum\ModeUtilisateur;
use App\Enum\StatutContrat;
use App\Enum\StatutPaiement;
use App\Service\Espaces;
use App\Service\Parametres;
use App\Service\Wallet;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Clock\ClockInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;

/** Wallet, fil d'activité et chiffres de l'Accueil. */
#[Route('/api/v1', methods: ['GET'])]
final class CompteController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly Wallet $wallet,
        private readonly Parametres $parametres,
        private readonly Espaces $espaces,
        private readonly ClockInterface $clock,
    ) {
    }

    /** R-147, R-148 : soldes par espace et total ; R-62 : seuil d'utilisation. */
    #[Route('/wallet')]
    public function wallet(Request $request): JsonResponse
    {
        $moi = $this->moi();
        $total = $this->wallet->solde($moi);
        $seuil = $this->parametres->entier(Parametres::WALLET_SEUIL_CENTIMES, $moi);
        $qb = $this->em->createQueryBuilder()->select('e')->from(EcritureWallet::class, 'e')
            ->where('e.user = :u')->setParameter('u', $moi)->orderBy('e.createdAt', 'DESC')->addOrderBy('e.id', 'DESC');
        $page = $this->page($request, $qb, $this->p->ecriture(...));
        $donnees = json_decode((string) $page->getContent(), true);

        return $this->json([
            'devise' => 'USD',
            'total' => $total,
            'soldes' => [
                'bailleur' => $this->wallet->solde($moi, EspaceWallet::Bailleur),
                'locataire' => $this->wallet->solde($moi, EspaceWallet::Locataire),
            ],
            'seuil' => $seuil,
            'utilisable' => $total >= $seuil,
            'ecritures' => $donnees,
        ]);
    }

    /**
     * R-173, R-174 : en mode bailleur, toute l'activité de son espace ; en mode
     * locataire, celle de ses propres contrats. Conservation de 12 mois.
     */
    #[Route('/activites')]
    public function activites(Request $request): JsonResponse
    {
        $moi = $this->moi();
        $mode = ModeUtilisateur::tryFrom((string) $request->query->get('mode', 'bailleur')) ?? ModeUtilisateur::Bailleur;
        $qb = $this->em->createQueryBuilder()->select('a')->from(Activite::class, 'a')
            ->where('a.createdAt >= :depuis')->setParameter('depuis', $this->clock->now()->modify('-12 months'))
            ->orderBy('a.createdAt', 'DESC')->addOrderBy('a.id', 'DESC');
        if (ModeUtilisateur::Bailleur === $mode) {
            $qb->andWhere('a.espace = :e OR a.destinataire = :u')->setParameter('e', $this->espaces->de($moi))->setParameter('u', $moi);
        } else {
            $qb->leftJoin('a.contrat', 'c')->leftJoin('c.locataire', 'l')
                ->andWhere('(l.utilisateur = :u AND a.type IN (:typesLocataire)) OR a.destinataire = :u')
                ->setParameter('u', $moi)
                ->setParameter('typesLocataire', ['paiement_enregistre', 'paiement_annule', 'declaration_validee', 'declaration_refusee', 'contrat_cree', 'contrat_cloture']);
        }

        return $this->page($request, $qb, $this->p->activite(...));
    }

    /** Chiffres de l'Accueil bailleur, calculés par le serveur (R-135). */
    #[Route('/tableau-de-bord')]
    public function tableauDeBord(): JsonResponse
    {
        $espace = $this->espaces->de($this->moi());
        if (null === $espace) {
            return $this->json(['unites' => 0, 'unitesLouees' => 0, 'unitesVacantes' => 0, 'contratsEnRetard' => 0, 'enRetard' => [], 'encaisseCeMois' => []]);
        }
        $unites = (int) $this->em->createQueryBuilder()->select('COUNT(u.id)')->from(Unite::class, 'u')
            ->join('u.propriete', 'p')->where('p.espace = :e')->setParameter('e', $espace)->getQuery()->getSingleScalarResult();
        $louees = (int) $this->em->createQueryBuilder()->select('COUNT(c.id)')->from(Contrat::class, 'c')
            ->join('c.unite', 'u')->join('u.propriete', 'p')
            ->where('p.espace = :e AND c.statut = :s')->setParameter('e', $espace)->setParameter('s', StatutContrat::Actif)
            ->getQuery()->getSingleScalarResult();
        $aujourdhui = $this->clock->now()->setTime(0, 0);

        $retards = $this->em->createQueryBuilder()
            ->select('d.code AS devise, SUM(e.montantDu - e.montantPaye) AS montant, COUNT(DISTINCT c.id) AS contrats')
            ->from(Echeance::class, 'e')->join('e.contrat', 'c')->join('c.devise', 'd')->join('c.unite', 'u')->join('u.propriete', 'p')
            ->where('p.espace = :e AND c.statut = :s AND e.annulee = false AND e.montantPaye < e.montantDu AND e.dateExigible < :auj')
            ->setParameter('e', $espace)->setParameter('s', StatutContrat::Actif)->setParameter('auj', $aujourdhui, 'date_immutable')
            ->groupBy('d.code')->getQuery()->getArrayResult();

        $encaisse = $this->em->createQueryBuilder()
            ->select('d.code AS devise, SUM(pa.montant) AS montant')
            ->from(Paiement::class, 'pa')->join('pa.contrat', 'c')->join('c.devise', 'd')->join('c.unite', 'u')->join('u.propriete', 'p')
            ->where('p.espace = :e AND pa.statut = :v AND pa.datePaiement >= :debut')
            ->setParameter('e', $espace)->setParameter('v', StatutPaiement::Valide)
            ->setParameter('debut', $aujourdhui->modify('first day of this month'), 'date_immutable')
            ->groupBy('d.code')->getQuery()->getArrayResult();

        return $this->json([
            'unites' => $unites,
            'unitesLouees' => $louees,
            'unitesVacantes' => $unites - $louees,
            'contratsEnRetard' => array_sum(array_map(static fn ($r) => (int) $r['contrats'], $retards)),
            'enRetard' => array_map(static fn ($r) => ['devise' => $r['devise'], 'montant' => (int) $r['montant']], $retards),
            'encaisseCeMois' => array_map(static fn ($r) => ['devise' => $r['devise'], 'montant' => (int) $r['montant']], $encaisse),
        ]);
    }
}
