<?php

namespace App\Service;

use App\Api\ErreurMetier;
use App\Entity\OtpCode;
use App\Entity\PaysApi;
use App\Entity\User;
use App\Enum\ModeUtilisateur;
use App\Securite\Chiffreur;
use App\Securite\Telephone;
use App\Sms\SmsEnvoyeurInterface;
use Doctrine\ORM\EntityManagerInterface;
use Gesdinet\JWTRefreshTokenBundle\Generator\RefreshTokenGeneratorInterface;
use Gesdinet\JWTRefreshTokenBundle\Model\RefreshTokenManagerInterface;
use Lexik\Bundle\JWTAuthenticationBundle\Services\JWTTokenManagerInterface;
use Psr\Clock\ClockInterface;
use Symfony\Component\RateLimiter\RateLimiterFactoryInterface;

/**
 * Section 7 : inscription et connexion par OTP (R-71, R-160), sans mot de passe.
 * Le PIN et la biométrie sont gérés sur le téléphone (R-141).
 */
final class Authentification
{
    private const OTP_VALIDITE_MINUTES = 10;
    private const JETON_INSCRIPTION_MINUTES = 30;
    private const REFRESH_TTL = 5184000; // 60 jours (R-140)

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly Chiffreur $chiffreur,
        private readonly SmsEnvoyeurInterface $sms,
        private readonly ClockInterface $clock,
        private readonly JWTTokenManagerInterface $jwt,
        private readonly RefreshTokenGeneratorInterface $refreshGenerateur,
        private readonly RefreshTokenManagerInterface $refreshManager,
        private readonly RateLimiterFactoryInterface $otpParTelephoneLimiter,
        private readonly RateLimiterFactoryInterface $otpParIpLimiter,
    ) {
    }

    public function demanderOtp(string $saisie, string $ip): void
    {
        $telephone = $this->normaliser($saisie);
        $empreinte = $this->chiffreur->empreinte($telephone);
        if (!$this->otpParTelephoneLimiter->create($empreinte)->consume()->isAccepted()
            || !$this->otpParIpLimiter->create($ip)->consume()->isAccepted()) {
            throw new ErreurMetier('TROP_DE_DEMANDES', 'Trop de demandes de code. Réessayez plus tard.', 429);
        }

        $code = str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        $this->em->persist(new OtpCode($empreinte, password_hash($code, PASSWORD_DEFAULT), $this->clock->now()->modify(\sprintf('+%d minutes', self::OTP_VALIDITE_MINUTES))));
        $this->em->flush();
        $this->sms->envoyer($telephone, \sprintf('Votre code CarnetDeLoyer : %s. Ne le partagez avec personne.', $code));
    }

    /**
     * @return array{utilisateur: ?User, jetonInscription: ?string}
     */
    public function verifierOtp(string $saisie, string $code): array
    {
        $telephone = $this->normaliser($saisie);
        $empreinte = $this->chiffreur->empreinte($telephone);
        $otp = $this->em->getRepository(OtpCode::class)->findOneBy(['telephoneEmpreinte' => $empreinte, 'utiliseLe' => null], ['createdAt' => 'DESC', 'id' => 'DESC']);
        $maintenant = $this->clock->now();

        if (null === $otp || $otp->getExpireLe() < $maintenant || $otp->getTentatives() >= OtpCode::MAX_TENTATIVES) {
            throw new ErreurMetier('OTP_EXPIRE', 'Code expiré : demandez un nouveau code.', 422);
        }
        $otp->incrementerTentatives();
        if (!password_verify($code, $otp->getCodeHash())) {
            $this->em->flush();
            throw ErreurMetier::champ('code', 'OTP_INVALIDE', 'Code incorrect.');
        }
        $otp->marquerUtilise();

        $user = $this->utilisateurParTelephone($telephone);
        $jeton = null;
        if (null === $user) {
            $jeton = bin2hex(random_bytes(32));
            $otp->emettreJetonInscription(hash('sha256', $jeton), $maintenant->modify(\sprintf('+%d minutes', self::JETON_INSCRIPTION_MINUTES)));
        } elseif (!$user->isActif()) {
            throw new ErreurMetier('COMPTE_SUSPENDU', 'Ce compte est suspendu.', 403);
        }
        $this->em->flush();

        return ['utilisateur' => $user, 'jetonInscription' => $jeton];
    }

    /**
     * R-160 : téléphone, OTP, nom, puis code parrain facultatif.
     */
    public function inscrire(string $saisie, string $jeton, string $nom, ?string $codeParrain): User
    {
        $telephone = $this->normaliser($saisie);
        $empreinte = $this->chiffreur->empreinte($telephone);
        $otp = $this->em->getRepository(OtpCode::class)->findOneBy(['jetonInscriptionHash' => hash('sha256', $jeton)]);
        if (null === $otp || $otp->getTelephoneEmpreinte() !== $empreinte || $otp->getJetonExpireLe() < $this->clock->now()) {
            throw new ErreurMetier('JETON_INSCRIPTION_INVALIDE', 'Session d\'inscription expirée : recommencez.', 422);
        }
        if (null !== $this->utilisateurParTelephone($telephone)) {
            throw new ErreurMetier('COMPTE_EXISTANT', 'Un compte existe déjà avec ce numéro.', 409);
        }
        $nom = trim($nom);
        if (mb_strlen($nom) < 2 || mb_strlen($nom) > 120) {
            throw ErreurMetier::champ('nom', 'NOM_INVALIDE', 'Indiquez votre nom (2 à 120 caractères).');
        }

        $parrain = null;
        if (null !== $codeParrain && '' !== trim($codeParrain)) {
            $parrain = $this->em->getRepository(User::class)->findOneBy(['codeParrainage' => strtoupper(trim($codeParrain))]);
            if (null === $parrain || !$parrain->isActif()) {
                throw ErreurMetier::champ('codeParrain', 'CODE_PARRAIN_INCONNU', 'Code parrain inconnu.');
            }
        }

        $user = new User($telephone, $empreinte, $nom, $this->nouveauCodeParrainage());
        $user->setParrain($parrain);
        $user->setPays($this->paysDepuisTelephone($telephone));
        $otp->consommerJeton();
        $this->em->persist($user);
        $this->em->flush();

        return $user;
    }

    /**
     * @return array{token: string, refresh_token: string, refresh_token_expiration: int}
     */
    public function jetons(User $user): array
    {
        $refresh = $this->refreshGenerateur->createForUserWithTtl($user, self::REFRESH_TTL);
        $this->refreshManager->save($refresh);

        return [
            'token' => $this->jwt->create($user),
            'refresh_token' => (string) $refresh->getRefreshToken(),
            'refresh_token_expiration' => $refresh->getValid()->getTimestamp(),
        ];
    }

    public function utilisateurParTelephone(string $telephone): ?User
    {
        return $this->em->getRepository(User::class)->findOneBy(['telephoneEmpreinte' => $this->chiffreur->empreinte($telephone)]);
    }

    /**
     * R-17 : pays déduit de l'indicatif (préfixe le plus long).
     */
    public function paysDepuisTelephone(string $telephone): ?PaysApi
    {
        $meilleur = null;
        foreach ($this->em->getRepository(PaysApi::class)->findBy(['active' => true]) as $pays) {
            if (str_starts_with($telephone, $pays->getIndicatif())
                && (null === $meilleur || \strlen($pays->getIndicatif()) > \strlen($meilleur->getIndicatif()))) {
                $meilleur = $pays;
            }
        }

        return $meilleur;
    }

    public function definirMode(User $user, ModeUtilisateur $mode): void
    {
        $user->setModePrefere($mode);
        $this->em->flush();
    }

    private function normaliser(string $saisie): string
    {
        return Telephone::normaliser($saisie) ?? throw ErreurMetier::champ('telephone', 'TELEPHONE_INVALIDE', 'Numéro de téléphone invalide (format international, ex. +243 970 000 000).');
    }

    private function nouveauCodeParrainage(): string
    {
        $alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
        do {
            $code = '';
            for ($i = 0; $i < 7; ++$i) {
                $code .= $alphabet[random_int(0, \strlen($alphabet) - 1)];
            }
        } while (null !== $this->em->getRepository(User::class)->findOneBy(['codeParrainage' => $code]));

        return $code;
    }
}
