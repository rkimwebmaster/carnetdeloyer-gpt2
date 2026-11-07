<?php

namespace App\Controller\Api;

use App\Api\Presentateur;
use App\Entity\CategorieUnite;
use App\Entity\Devise;
use App\Entity\PaysApi;
use App\Entity\VilleApi;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Attribute\Route;

/**
 * R-15 : API publique en lecture seule, accessible sans connexion
 * (nécessaire à l'inscription). Seules les entrées actives sont exposées.
 */
#[Route('/api/v1/referentiels', methods: ['GET'])]
final class ReferentielController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
    ) {
    }

    #[Route('/pays')]
    public function pays(): JsonResponse
    {
        $pays = $this->em->getRepository(PaysApi::class)->findBy(['active' => true], ['nom' => 'ASC']);

        return $this->publicEnCache($this->json(array_map($this->p->pays(...), $pays)));
    }

    #[Route('/pays/{id<\d+>}/villes')]
    public function villes(int $id, Request $request): JsonResponse
    {
        $qb = $this->em->createQueryBuilder()->select('v')->from(VilleApi::class, 'v')
            ->join('v.pays', 'p')
            ->where('p.id = :id AND p.active = true AND v.active = true')->setParameter('id', $id)
            ->orderBy('v.nom', 'ASC');
        $recherche = trim((string) $request->query->get('q', ''));
        if ('' !== $recherche) {
            $qb->andWhere('v.nom LIKE :q')->setParameter('q', addcslashes($recherche, '%_').'%');
        }

        return $this->publicEnCache($this->json(array_map($this->p->ville(...), $qb->setMaxResults(500)->getQuery()->getResult())));
    }

    #[Route('/devises')]
    public function devises(): JsonResponse
    {
        $devises = $this->em->getRepository(Devise::class)->findBy(['active' => true], ['code' => 'ASC']);

        return $this->publicEnCache($this->json(array_map($this->p->devise(...), $devises)));
    }

    #[Route('/categories')]
    public function categories(): JsonResponse
    {
        $categories = $this->em->getRepository(CategorieUnite::class)->findBy(['active' => true], ['libelle' => 'ASC']);

        return $this->publicEnCache($this->json(array_map($this->p->categorie(...), $categories)));
    }

    private function publicEnCache(JsonResponse $r): JsonResponse
    {
        return $r->setPublic()->setMaxAge(3600);
    }
}
