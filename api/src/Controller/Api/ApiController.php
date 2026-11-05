<?php

namespace App\Controller\Api;

use App\Entity\User;
use Doctrine\ORM\QueryBuilder;
use Doctrine\ORM\Tools\Pagination\Paginator;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

abstract class ApiController extends AbstractController
{
    protected const PAR_PAGE_MAX = 50;

    protected function moi(): User
    {
        $user = $this->getUser();
        if (!$user instanceof User) {
            throw $this->createAccessDeniedException();
        }

        return $user;
    }

    /**
     * R-151 : API paginée. Réponse { elements: [...], page, parPage, total }.
     *
     * @param callable(mixed): array $presenter
     */
    protected function page(Request $request, QueryBuilder $qb, callable $presenter): JsonResponse
    {
        $page = max(1, $request->query->getInt('page', 1));
        $parPage = min(self::PAR_PAGE_MAX, max(1, $request->query->getInt('parPage', 20)));
        $qb->setFirstResult(($page - 1) * $parPage)->setMaxResults($parPage);
        $paginator = new Paginator($qb, fetchJoinCollection: false);

        return $this->json([
            'elements' => array_map($presenter, iterator_to_array($paginator->getIterator())),
            'page' => $page,
            'parPage' => $parPage,
            'total' => \count($paginator),
        ]);
    }

    protected static function dateDepuis(string $valeur): \DateTimeImmutable
    {
        return new \DateTimeImmutable($valeur.' 00:00:00');
    }
}
