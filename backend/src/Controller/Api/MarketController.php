<?php

namespace App\Controller\Api;

use App\Api\ErreurMetier;
use App\Api\Presentateur;
use App\Entity\Propriete;
use App\Entity\TraceMarket;
use App\Entity\Unite;
use App\Enum\BadgeVerification;
use App\Enum\StatutContrat;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\QueryBuilder;
use Psr\Clock\ClockInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Vitrines v0.1 : Market (R-107) et Hôtels (R-97, R-98).
 * Tous les visiteurs sont connectés (R-09) : consultations et contacts sont tracés (R-101).
 */
#[Route('/api/v1')]
final class MarketController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly ClockInterface $clock,
    ) {
    }

    /** ?paysId, ?villeId, ?categorie, ?q */
    #[Route('/market/annonces', methods: ['GET'])]
    public function annonces(Request $request): JsonResponse
    {
        $qb = $this->annoncesQb()->orderBy('u.publieeLe', 'DESC');
        if ($paysId = $request->query->getInt('paysId')) {
            $qb->andWhere('p.pays = :pays')->setParameter('pays', $paysId);
        }
        if ($villeId = $request->query->getInt('villeId')) {
            $qb->andWhere('p.ville = :ville')->setParameter('ville', $villeId);
        }
        if ($categorie = $request->query->get('categorie')) {
            $qb->andWhere('cat.code = :cat')->setParameter('cat', $categorie);
        }

        return $this->page($request, $qb, fn (Unite $u) => $this->annonce($u, false));
    }

    #[Route('/market/annonces/{id<\d+>}', methods: ['GET'])]
    public function annonce_(int $id): JsonResponse
    {
        $unite = $this->annoncesQb()->andWhere('u.id = :id')->setParameter('id', $id)->getQuery()->getOneOrNullResult()
            ?? throw ErreurMetier::introuvable('Annonce');
        $this->tracer(TraceMarket::CONSULTATION, $unite);

        return $this->json($this->annonce($unite, true));
    }

    /** R-101 : contact par WhatsApp ou appel, tracé. */
    #[Route('/market/annonces/{id<\d+>}/contact', methods: ['POST'])]
    public function contacter(int $id): JsonResponse
    {
        $unite = $this->annoncesQb()->andWhere('u.id = :id')->setParameter('id', $id)->getQuery()->getOneOrNullResult()
            ?? throw ErreurMetier::introuvable('Annonce');
        $this->tracer(TraceMarket::CONTACT, $unite);

        return $this->json(['telephone' => $unite->getEspace()->getProprietaire()->getTelephone(), 'nom' => $unite->getEspace()->nomAffiche()]);
    }

    /** R-97 : propriétés de catégorie hôtel, position exacte et contact. */
    #[Route('/hotels', methods: ['GET'])]
    public function hotels(Request $request): JsonResponse
    {
        $qb = $this->em->createQueryBuilder()->select('p')->from(Propriete::class, 'p')
            ->join('p.espace', 'e')
            ->where('e.badge = :badge AND (e.badgeExpireLe IS NULL OR e.badgeExpireLe >= :maintenant)')
            ->andWhere('EXISTS (SELECT u.id FROM App\Entity\Unite u JOIN u.categorie cat WHERE u.propriete = p AND cat.hotel = true)')
            ->setParameter('badge', BadgeVerification::Entreprise)->setParameter('maintenant', $this->clock->now())
            ->orderBy('p.nom', 'ASC');
        if ($villeId = $request->query->getInt('villeId')) {
            $qb->andWhere('p.ville = :ville')->setParameter('ville', $villeId);
        }
        if ($paysId = $request->query->getInt('paysId')) {
            $qb->andWhere('p.pays = :pays')->setParameter('pays', $paysId);
        }

        return $this->page($request, $qb, $this->hotel(...));
    }

    private function annoncesQb(): QueryBuilder
    {
        return $this->em->createQueryBuilder()->select('u')->from(Unite::class, 'u')
            ->join('u.propriete', 'p')->join('u.categorie', 'cat')
            ->where('u.publieeMarket = true AND cat.hotel = false')
            ->andWhere('NOT EXISTS (SELECT c.id FROM App\Entity\Contrat c WHERE c.unite = u AND c.statut = :actif)')
            ->setParameter('actif', StatutContrat::Actif);
    }

    private function annonce(Unite $u, bool $detail): array
    {
        $p = $u->getPropriete();
        $espace = $u->getEspace();
        $donnees = [
            'id' => $u->getId(),
            'titre' => $u->getNom(),
            'categorie' => $this->p->categorie($u->getCategorie()),
            'prix' => null === $u->getLoyerIndicatif() ? null : ['montant' => $u->getLoyerIndicatif(), 'devise' => $u->getDeviseIndicative()?->getCode()],
            // R-88 : zone approximative seulement ; quartier, ville et pays toujours visibles (R-106).
            'zone' => ['quartier' => $p->getQuartier(), 'ville' => $p->getVille()?->getNom(), 'pays' => $p->getPays()->getNom()],
            'description' => $u->getDescriptionMarket(),
            'bailleur' => ['nom' => $espace->nomAffiche(), 'badge' => $espace->getBadge($this->clock->now())?->value],
            'publieeLe' => Presentateur::dateHeure($u->getPublieeLe()),
        ];
        if ($detail) {
            $donnees['positionApproximative'] = $this->approximer($p->getLatitude(), $p->getLongitude());
        }

        return $donnees;
    }

    private function hotel(Propriete $p): array
    {
        $prix = $this->em->createQueryBuilder()->select('MIN(u.loyerIndicatif) AS prix, IDENTITY(u.deviseIndicative) AS devise')
            ->from(Unite::class, 'u')->join('u.categorie', 'cat')
            ->where('u.propriete = :p AND cat.hotel = true AND u.loyerIndicatif IS NOT NULL')->setParameter('p', $p)
            ->groupBy('u.deviseIndicative')->setMaxResults(1)->getQuery()->getOneOrNullResult();
        $devise = null === $prix ? null : $this->em->find(\App\Entity\Devise::class, (int) $prix['devise']);

        return [
            'id' => $p->getId(), 'nom' => $p->getNom(), 'adresse' => $p->getAdresse(), 'quartier' => $p->getQuartier(),
            'ville' => $p->getVille()?->getNom(), 'pays' => $p->getPays()->getNom(),
            // R-88 : position exacte affichée pour les hôtels.
            'latitude' => $p->getLatitude(), 'longitude' => $p->getLongitude(),
            'prixParNuitDes' => null === $prix ? null : ['montant' => (int) $prix['prix'], 'devise' => $devise?->getCode()],
            'contact' => ['nom' => $p->getEspace()->nomAffiche(), 'telephone' => $p->getEspace()->getProprietaire()->getTelephone()],
            'badge' => $p->getEspace()->getBadge($this->clock->now())?->value,
        ];
    }

    /** @return array{latitude: float, longitude: float}|null arrondi à ~1 km */
    private function approximer(?float $lat, ?float $lng): ?array
    {
        return null === $lat || null === $lng ? null : ['latitude' => round($lat, 2), 'longitude' => round($lng, 2)];
    }

    private function tracer(string $action, Unite $unite): void
    {
        $this->em->persist(new TraceMarket($this->moi(), $action, $unite));
        $this->em->flush();
    }
}
