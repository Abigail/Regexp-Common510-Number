#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp 2013041801;

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

my $letter_test = Test::Regexp:: -> new -> init (
                      pattern      => RE (Number => 'integer',
                                         -chars  => $letters),
                      keep_pattern => RE (Number => 'integer',
                                         -chars  => $letters,
                                         -Keep   => 1),
                      name         => "Letters",
                      full_text    =>  1
);

my $cham_test   = Test::Regexp:: -> new -> init (
                      pattern      => RE (Number => 'integer',
                                         -chars  => $cham),
                      keep_pattern => RE (Number => 'integer',
                                         -chars  => $cham,
                                         -Keep   => 1),
                      name         => "Non-ASCII characters",
                      full_text    =>  1
);

my $evens_test  = Test::Regexp:: -> new -> init (
                      pattern      => RE (Number => 'integer',
                                         -chars  => $evens),
                      keep_pattern => RE (Number => 'integer',
                                         -chars  => $evens,
                                         -Keep   => 1),
                      name         => "Less than 10 chars in -chars",
                      full_text    =>  1
);

my $even2_test  = Test::Regexp:: -> new -> init (
                      pattern      => RE (Number => 'integer',
                                         -base   =>  2,
                                         -chars  => $evens),
                      keep_pattern => RE (Number => 'integer',
                                         -base   =>  2,
                                         -chars  => $evens,
                                         -Keep   => 1),
                      name         => "-base less than -char length",
                      full_text    =>  1
);

my $special_test  = Test::Regexp:: -> new -> init (
                      pattern      => RE (Number => 'integer',
                                         -chars  => $special),
                      keep_pattern => RE (Number => 'integer',
                                         -chars  => $special,
                                         -Keep   => 1),
                      name         => "Special chars",
                      full_text    =>  1
);

foreach my $number ("A", "Z", "ABCDEFGHIJKLMNOPQRSTUVWXYZ") {
    my $signed = "+$number";

    $letter_test -> match ($number,
                            test      => "Letter number",
                            captures  =>  [[number     => $number],
                                           [sign       => ''],
                                           [abs_number => $number]],
    );

    $letter_test -> match ($signed,
                            test      => "Signed letter number",
                            captures  =>  [[number     => $signed],
                                           [sign       => '+'],
                                           [abs_number => $number]],
    );
}

foreach my $number (0 .. 9) {
    $letter_test -> no_match ($number,
                               reason => "Digits should not match letters");
}


foreach my $number ("\N{CHAM DIGIT ZERO}", "\N{CHAM DIGIT ONE}",
                    "\N{CHAM DIGIT NINE}\N{CHAM DIGIT THREE}\N{CHAM DIGIT SIX}",
                    "\N{CHAM DIGIT ZERO}\N{CHAM DIGIT ZERO}") {
    my $signed = "-$number";

    $cham_test -> match ($number,
                          test      => "Cham number",
                          captures  =>  [[number     => $number],
                                         [sign       => ''],
                                         [abs_number => $number]],
    );

    $cham_test -> match ($signed,
                          test      => "Signed Cham number",
                          captures  =>  [[number     => $signed],
                                         [sign       => '-'],
                                         [abs_number => $number]],
    );
}


foreach my $number ("0", "86420", "86" x 50) {
    $evens_test -> match ($number,
                           test     =>  "Even numbers",
                           captures =>  [[number     => $number],
                                         [sign       => ''],
                                         [abs_number => $number]],
    );
}

foreach my $number ("0", "2") {
    $even2_test -> match ($number,
                           test     =>  "Even number",
                           captures =>  [[number     => $number],
                                         [sign       => ''],
                                         [abs_number => $number]],
    );
}

foreach my $number ("4", "6", "8") {
    $even2_test -> no_match ($number,
                              reason => "Digits exceeding base");
}


foreach my $number ("0", "-", "9", "[", "]", "[9[0]-]") {
    my $signed = "-$number";

    $special_test -> match ($number,
                             test     =>  "Meta characters",
                             captures =>  [[number     => $number],
                                           [sign       => ''],
                                           [abs_number => $number]],
    );
 
    $special_test -> match ($signed,
                             test     =>  "Signed meta characters",
                             captures =>  [[number     => $signed],
                                           [sign       => '-'],
                                           [abs_number => $number]],
    );
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
