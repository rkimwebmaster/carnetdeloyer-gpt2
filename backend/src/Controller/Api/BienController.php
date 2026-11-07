<?php

namespace App\Controller\Api;

use App\Api\Dto\ModificationPropriete;
use App\Api\Dto\ModificationUnite;
use App\Api\Dto\NouvellePropriete;
use App\Api\Dto\NouvelleUnite;
use App\Api\Dto\Publication;
use App\Api\Presentateur;
use App\Entity\Propriete;
use App\Entity\Unite;
use App\Securite\Acces;
use App\Service\Biens;
use App\Service\Espaces;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Attribute\Route;

/** Onglet Biens (mode bailleur). */
#[Route('/api/v1')]
final class BienController extends ApiController
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Presentateur $p,
        private readonly Acces $acces,
        private readonly Biens $biens,
        private readonly Espaces $espaces,
    ) {
    }

    #[Route('/proprietes', methods: ['GET'])]
    public function proprietes(Request $request): JsonResponse
    {
        $espace = $this->espaces->de($this->moi());
        $qb = $this->em->createQueryBuilder()->select('p')->from(Propriete::class, 'p')
            ->where('p.espace = :e')->setParameter('e', $espace)->orderBy('p.nom', 'ASC');

        return $this->page($request, $qb, fn (Propriete $p) => $this->p->propriete($p, $this->nbUnites($p)));
    }

    #[Route('/proprietes', methods: ['POST'])]
    public function creerPropriete(#[MapRequestPayload] NouvellePropriete $dto): JsonResponse
    {
        $propriete = $this->biens->creerPropriete($this->moi(), $dto);

        return $this->json($this->detailPropriete($propriete), 201);
    }

    #[Route('/proprietes/{id<\d+>}', methods: ['GET'])]
    public function propriete(int $id): JsonResponse
    {
        return $this->json($this->detailPropriete($this->acces->propriete($this->moi(), $id)));
    }

    #[Route('/proprietes/{id<\d+>}', methods: ['PATCH'])]
    public function modifierPropriete(int $id, #[MapRequestPayload] ModificationPropriete $dto): JsonResponse
    {
        $propriete = $this->acces->propriete($this->moi(), $id);
        if (null !== $dto->nom) {
            $propriete->setNom(trim($dto->nom));
        }
        if (null !== $dto->adresse) {
            $propriete->setAdresse($dto->adresse ?: null);
        }
        if (null !== $dto->quartier) {
            $propriete->setQuartier($dto->quartier ?: null);
        }
        if (null !== $dto->villeId) {
            $propriete->setVille($this->biens->ville($dto->villeId, $propriete->getPays()));
        }
        if (null !== $dto->latitude && null !== $dto->longitude) {
            $propriete->setCoordonnees($dto->latitude, $dto->longitude);
        }
        $this->em->flush();

        return $this->json($this->detailPropriete($propriete));
    }

    #[Route('/proprietes/{id<\d+>}/unites', methods: ['POST'])]
    public function ajouterUnite(int $id, #[MapRequestPayload] NouvelleUnite $dto): JsonResponse
    {
        $propriete = $this->acces->propriete($this->moi(), $id);
        $unite = $this->biens->ajouterUnite($propriete, $dto);
        $this->em->flush();

        return $this->json($this->p->unite($unite), 201);
    }

    /** Liste à plat des unités ; ?vacantes=1 pour les unités sans contrat actif. */
    #[Route('/unites', methods: ['GET'])]
    public function unites(Request $request): JsonResponse
    {
        $espace = $this->espaces->de($this->moi());
        $qb = $this->em->createQueryBuilder()->select('u')->from(Unite::class, 'u')
            ->join('u.propriete', 'p')->where('p.espace = :e')->setParameter('e', $espace)
            ->orderBy('p.nom', 'ASC')->addOrderBy('u.nom', 'ASC');
        if ($request->query->getBoolean('vacantes')) {
            $qb->andWhere("NOT EXISTS (SELECT c.id FROM App\Entity\Contrat c WHERE c.unite = u AND c.statut = 'actif')");
        }

        return $this->page($request, $qb, $this->p->unite(...));
    }

    #[Route('/unites/{id<\d+>}', methods: ['GET'])]
    public function unite(int $id): JsonResponse
    {
        return $this->json($this->p->unite($this->acces->unite($this->moi(), $id)));
    }

    #[Route('/unites/{id<\d+>}', methods: ['PATCH'])]
    public function modifierUnite(int $id, #[MapRequestPayload] ModificationUnite $dto): JsonResponse
    {
        $unite = $this->acces->unite($this->moi(), $id);
        $this->biens->modifierUnite($unite, $dto->nom, $dto->categorie, $dto->loyerIndicatif, $dto->devise);

        return $this->json($this->p->unite($unite));
    }

    #[Route('/unites/{id<\d+>}/publication', methods: ['POST'])]
    public function publier(int $id, #[MapRequestPayload] Publication $dto): JsonResponse
    {
        $moi = $this->moi();
        $unite = $this->acces->unite($moi, $id);
        $this->biens->publier($moi, $unite, $dto->description);

        return $this->json($this->p->unite($unite));
    }

    #[Route('/unites/{id<\d+>}/publication', methods: ['DELETE'])]
    public function retirer(int $id): JsonResponse
    {
        $unite = $this->acces->unite($this->moi(), $id);
        $unite->retirerDuMarket();
        $this->em->flush();

        return $this->json($this->p->unite($unite));
    }

    private function detailPropriete(Propriete $propriete): array
    {
        $unites = $this->em->getRepository(Unite::class)->findBy(['propriete' => $propriete], ['nom' => 'ASC']);

        return $this->p->propriete($propriete, \count($unites)) + [
            'unites' => array_map(fn (Unite $u) => $this->p->unite($u, false), $unites),
        ];
    }

    private function nbUnites(Propriete $p): int
    {
        return $this->em->getRepository(Unite::class)->count(['propriete' => $p]);
    }
}
