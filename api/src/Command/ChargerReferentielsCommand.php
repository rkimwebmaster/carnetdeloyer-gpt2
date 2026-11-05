<?php

namespace App\Command;

use App\Entity\CategorieUnite;
use App\Entity\Devise;
use App\Entity\PaysApi;
use App\Entity\VilleApi;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Charge un jeu de départ de référentiels (R-15, R-117). Idempotent : ajoute ce
 * qui manque, ne modifie ni ne supprime rien. La suite se gère depuis le back-office.
 */
#[AsCommand('app:referentiels:charger', 'Charge les devises, pays, villes et catégories d\'unités de départ')]
final class ChargerReferentielsCommand extends Command
{
    /** code => [nom, symbole, décimales ISO 4217] */
    private const DEVISES = [
        'USD' => ['Dollar américain', '$', 2], 'CDF' => ['Franc congolais', 'FC', 2], 'EUR' => ['Euro', '€', 2],
        'XAF' => ['Franc CFA (CEMAC)', 'FCFA', 0], 'XOF' => ['Franc CFA (UEMOA)', 'FCFA', 0], 'RWF' => ['Franc rwandais', 'FRw', 0],
        'BIF' => ['Franc burundais', 'FBu', 0], 'UGX' => ['Shilling ougandais', 'USh', 0], 'KES' => ['Shilling kényan', 'KSh', 2],
        'TZS' => ['Shilling tanzanien', 'TSh', 2], 'ZMW' => ['Kwacha zambien', 'ZK', 2], 'AOA' => ['Kwanza angolais', 'Kz', 2],
        'NAD' => ['Dollar namibien', 'N$', 2], 'ZAR' => ['Rand sud-africain', 'R', 2], 'NGN' => ['Naira nigérian', '₦', 2],
        'GHS' => ['Cedi ghanéen', 'GH₵', 2], 'MAD' => ['Dirham marocain', 'DH', 2], 'GBP' => ['Livre sterling', '£', 2],
        'CAD' => ['Dollar canadien', 'CA$', 2], 'CHF' => ['Franc suisse', 'CHF', 2],
    ];

    /** [nom, iso2, iso3, indicatif, devise, drapeau, villes] */
    private const PAYS = [
        ['République démocratique du Congo', 'CD', 'COD', '+243', 'CDF', '🇨🇩', ['Kinshasa', 'Lubumbashi', 'Goma', 'Bukavu', 'Kisangani', 'Kolwezi', 'Likasi', 'Mbuji-Mayi', 'Kananga', 'Matadi', 'Boma', 'Uvira', 'Butembo', 'Beni', 'Kindu', 'Kalemie', 'Mbandaka', 'Bunia']],
        ['République du Congo', 'CG', 'COG', '+242', 'XAF', '🇨🇬', ['Brazzaville', 'Pointe-Noire', 'Dolisie']],
        ['Rwanda', 'RW', 'RWA', '+250', 'RWF', '🇷🇼', ['Kigali', 'Rubavu', 'Huye', 'Musanze']],
        ['Burundi', 'BI', 'BDI', '+257', 'BIF', '🇧🇮', ['Bujumbura', 'Gitega', 'Ngozi']],
        ['Ouganda', 'UG', 'UGA', '+256', 'UGX', '🇺🇬', ['Kampala', 'Entebbe', 'Gulu', 'Mbarara']],
        ['Kenya', 'KE', 'KEN', '+254', 'KES', '🇰🇪', ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru']],
        ['Tanzanie', 'TZ', 'TZA', '+255', 'TZS', '🇹🇿', ['Dar es Salaam', 'Dodoma', 'Arusha', 'Mwanza']],
        ['Zambie', 'ZM', 'ZMB', '+260', 'ZMW', '🇿🇲', ['Lusaka', 'Ndola', 'Kitwe']],
        ['Angola', 'AO', 'AGO', '+244', 'AOA', '🇦🇴', ['Luanda', 'Lobito', 'Huambo']],
        ['Namibie', 'NA', 'NAM', '+264', 'NAD', '🇳🇦', ['Windhoek', 'Walvis Bay', 'Swakopmund']],
        ['Afrique du Sud', 'ZA', 'ZAF', '+27', 'ZAR', '🇿🇦', ['Johannesburg', 'Le Cap', 'Durban', 'Pretoria']],
        ['Cameroun', 'CM', 'CMR', '+237', 'XAF', '🇨🇲', ['Douala', 'Yaoundé', 'Bafoussam']],
        ['Gabon', 'GA', 'GAB', '+241', 'XAF', '🇬🇦', ['Libreville', 'Port-Gentil']],
        ['Côte d\'Ivoire', 'CI', 'CIV', '+225', 'XOF', '🇨🇮', ['Abidjan', 'Bouaké', 'Yamoussoukro']],
        ['Sénégal', 'SN', 'SEN', '+221', 'XOF', '🇸🇳', ['Dakar', 'Thiès', 'Saint-Louis']],
        ['Bénin', 'BJ', 'BEN', '+229', 'XOF', '🇧🇯', ['Cotonou', 'Porto-Novo', 'Parakou']],
        ['Togo', 'TG', 'TGO', '+228', 'XOF', '🇹🇬', ['Lomé', 'Kara']],
        ['Mali', 'ML', 'MLI', '+223', 'XOF', '🇲🇱', ['Bamako']],
        ['Burkina Faso', 'BF', 'BFA', '+226', 'XOF', '🇧🇫', ['Ouagadougou', 'Bobo-Dioulasso']],
        ['Nigeria', 'NG', 'NGA', '+234', 'NGN', '🇳🇬', ['Lagos', 'Abuja', 'Port Harcourt']],
        ['Ghana', 'GH', 'GHA', '+233', 'GHS', '🇬🇭', ['Accra', 'Kumasi']],
        ['Maroc', 'MA', 'MAR', '+212', 'MAD', '🇲🇦', ['Casablanca', 'Rabat', 'Marrakech']],
        ['France', 'FR', 'FRA', '+33', 'EUR', '🇫🇷', ['Paris', 'Lyon', 'Marseille', 'Lille']],
        ['Belgique', 'BE', 'BEL', '+32', 'EUR', '🇧🇪', ['Bruxelles', 'Liège', 'Anvers']],
        ['Suisse', 'CH', 'CHE', '+41', 'CHF', '🇨🇭', ['Genève', 'Lausanne', 'Zurich']],
        ['Royaume-Uni', 'GB', 'GBR', '+44', 'GBP', '🇬🇧', ['Londres', 'Manchester']],
        ['Canada', 'CA', 'CAN', '+1', 'CAD', '🇨🇦', ['Montréal', 'Toronto', 'Ottawa']],
        ['États-Unis', 'US', 'USA', '+1', 'USD', '🇺🇸', ['New York', 'Washington', 'Houston', 'Atlanta']],
    ];

    /** code => [libellé, icône Material Symbols, hôtel] */
    private const CATEGORIES = [
        'maison' => ['Maison', 'house', false],
        'appartement' => ['Appartement', 'apartment', false],
        'studio' => ['Studio', 'bed', false],
        'chambre' => ['Chambre', 'single_bed', false],
        'boutique' => ['Boutique', 'storefront', false],
        'bureau' => ['Bureau', 'business_center', false],
        'entrepot' => ['Entrepôt', 'warehouse', false],
        'terrain' => ['Terrain', 'landscape', false],
        'chambre_hotel' => ['Chambre d\'hôtel', 'hotel', true],
    ];

    public function __construct(private readonly EntityManagerInterface $em)
    {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $devises = [];
        foreach (self::DEVISES as $code => [$nom, $symbole, $decimales]) {
            $devises[$code] = $this->em->getRepository(Devise::class)->findOneBy(['code' => $code]) ?? $this->persister(new Devise($code, $nom, $symbole, $decimales));
        }
        foreach (self::PAYS as [$nom, $iso2, $iso3, $indicatif, $devise, $drapeau, $villes]) {
            $pays = $this->em->getRepository(PaysApi::class)->findOneBy(['codeIso' => $iso2]) ?? $this->persister(new PaysApi($nom, $iso2, $iso3, $indicatif, $devises[$devise], $drapeau));
            foreach ($villes as $ville) {
                if (null === $pays->getId() || null === $this->em->getRepository(VilleApi::class)->findOneBy(['pays' => $pays, 'nom' => $ville])) {
                    $this->persister(new VilleApi($pays, $ville));
                }
            }
        }
        foreach (self::CATEGORIES as $code => [$libelle, $icone, $hotel]) {
            if (null === $this->em->getRepository(CategorieUnite::class)->findOneBy(['code' => $code])) {
                $this->persister(new CategorieUnite($code, $libelle, $icone, $hotel));
            }
        }
        $this->em->flush();
        $output->writeln('Référentiels chargés.');

        return Command::SUCCESS;
    }

    /**
     * @template T of object
     *
     * @param T $entite
     *
     * @return T
     */
    private function persister(object $entite): object
    {
        $this->em->persist($entite);

        return $entite;
    }
}
