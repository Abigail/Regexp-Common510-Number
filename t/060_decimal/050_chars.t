#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

use charnames ':full';

my $letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
my $cham    = "\N{CHAM DIGIT ZERO}\N{CHAM DIGIT ONE}\N{CHAM DIGIT TWO}"    .
              "\N{CHAM DIGIT THREE}\N{CHAM DIGIT FOUR}\N{CHAM DIGIT FIVE}" .
              "\N{CHAM DIGIT SIX}\N{CHAM DIGIT SEVEN}\N{CHAM DIGIT EIGHT}" .
              "\N{CHAM DIGIT NINE}";
my $evens   = "02468";
my $special = "0-9[]";
my @C       = map {chr ($_ + ord "\N{CHAM DIGIT ZERO}")} 0 .. 9;

my $letter_test  = decimal_tester -args => [-chars => $letters],
                                  -name => "-chars letters";

my $cham_test    = decimal_tester -args => [-chars => $cham],
                                  -name => "-chars Cham digits";

my $evens_test   = decimal_tester -args => [-chars => $evens],
                                  -name => "-chars short list";

my $even2_test   = decimal_tester -args => [-chars => $evens, -base => 2],
                                  -name => "-chars short list; lower -base";

my $special_test = decimal_tester -args => [-chars => $special],
                                  -name => "-chars with [] meta chars";


foreach my $number ("A", ".Z", "WXQ.", "ABCDEFGHIJ.KLMNOPQRSTUVWXYZ") {
    my $signed = "+$number";

    my ($integer, $radix, $fraction) = split /([.])/ => $number;

    $letter_test -> match ($number,
                            test      => "Letter number",
                            captures  =>  [[number     => $number],
                                           [sign       => ''],
                                           [abs_number => $number],
                                           [integer    => $integer],
                                           [radix      => $radix],
                                           [fraction   => $fraction]],
    );

    $letter_test -> match ($signed,
                            test      => "Signed letter number",
                            captures  =>  [[number     => $signed],
                                           [sign       => '+'],
                                           [abs_number => $number],
                                           [integer    => $integer],
                                           [radix      => $radix],
                                           [fraction   => $fraction]],
    );
}

foreach my $number (0 .. 9, "ABC.D1F", "+.F1") {
    $letter_test -> no_match ($number,
                               reason => "Digits should not match letters");
}

foreach my $number ("$C[0]", "$C[1]$C[2].", "$C[9]$C[8]$C[7].$C[6]$C[5]$C[4]",
                    ".$C[3]$C[2]$C[1]$C[0]") {
    my $signed = "-$number";

    my ($integer, $radix, $fraction) = split /([.])/ => $number;

    $cham_test -> match ($number,
                          test      => "Cham number",
                          captures  =>  [[number     => $number],
                                         [sign       => ''],
                                         [abs_number => $number],
                                         [integer    => $integer],
                                         [radix      => $radix],
                                         [fraction   => $fraction]],
    );

    $cham_test -> match ($signed,
                          test      => "Signed Cham number",
                          captures  =>  [[number     => $signed],
                                         [sign       => '-'],
                                         [abs_number => $number],
                                         [integer    => $integer],
                                         [radix      => $radix],
                                         [fraction   => $fraction]],
    );
}


foreach my $number ("0", "2466.", ".22200", "864.20",
                   ("86" x 25) . "." . ("024" x 25)) {
    my ($integer, $radix, $fraction) = split /([.])/ => $number;

    $evens_test -> match ($number,
                           test     =>  "Even numbers",
                           captures =>  [[number     => $number],
                                         [sign       => ''],
                                         [abs_number => $number],
                                         [integer    => $integer],
                                         [radix      => $radix],
                                         [fraction   => $fraction]],
    );
}

foreach my $number ("0", "2.", ".000", "2020200.00202200202022002") {
    my ($integer, $radix, $fraction) = split /([.])/ => $number;

    $even2_test -> match ($number,
                           test     =>  "Even number",
                           captures =>  [[number     => $number],
                                         [sign       => ''],
                                         [abs_number => $number],
                                         [integer    => $integer],
                                         [radix      => $radix],
                                         [fraction   => $fraction]],
    );
}

foreach my $number ("4", "6.", "02.022002020028202000202202") {
    $even2_test -> no_match ($number,
                              reason => "Digits exceeding base");
}


foreach my $number ("0", ".-", "9[.", "[].---90[[[") {
    my ($integer, $radix, $fraction) = split /([.])/ => $number;

    my $signed = "-$number";

    $special_test -> match ($number,
                             test     =>  "Meta characters",
                             captures =>  [[number     => $number],
                                           [sign       => ''],
                                           [abs_number => $number],
                                           [integer    => $integer],
                                           [radix      => $radix],
                                           [fraction   => $fraction]],
    );
 
    $special_test -> match ($signed,
                             test     =>  "Signed meta characters",
                             captures =>  [[number     => $signed],
                                           [sign       => '-'],
                                           [abs_number => $number],
                                           [integer    => $integer],
                                           [radix      => $radix],
                                           [fraction   => $fraction]],
    );
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;


__END__
