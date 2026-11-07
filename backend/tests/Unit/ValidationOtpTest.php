<?php

namespace App\Tests\Unit;

use App\Securite\ValidationOtp;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

final class ValidationOtpTest extends TestCase
{
    public function testDevAccepteUnCodeArbitraireDeSixChiffres(): void
    {
        $validation = new ValidationOtp('dev');
        self::assertTrue($validation->estDeveloppement());
        $hash = password_hash('111111', PASSWORD_DEFAULT);
        self::assertTrue($validation->correspond('234567', $hash));
        self::assertTrue($validation->correspond('000000', $hash));
    }

    public function testDevConserveLaValidationDuFormat(): void
    {
        $validation = new ValidationOtp('dev');
        foreach (['', '23456', '2345678', 'abcdef', '234567' . "\n"] as $code) {
            self::assertFalse($validation->correspond($code, password_hash('111111', PASSWORD_DEFAULT)));
        }
    }

    #[DataProvider('environnementsProteges')]
    public function testHorsDevExigeLeVraiCode(string $environnement): void
    {
        $validation = new ValidationOtp($environnement);
        self::assertFalse($validation->estDeveloppement());
        $hash = password_hash('111111', PASSWORD_DEFAULT);
        self::assertFalse($validation->correspond('234567', $hash));
        self::assertTrue($validation->correspond('111111', $hash));
    }

    public static function environnementsProteges(): iterable
    {
        yield ['prod'];
        yield ['test'];
        yield ['staging'];
        yield ['development'];
    }
}
