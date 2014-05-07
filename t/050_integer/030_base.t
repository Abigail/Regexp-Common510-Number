#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use warnings 'Regexp::Common510';

our $r = eval "require Test::NoWarnings; 1";

my %test;

my $chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

my $PLAIN = 0;
my $LOWER = 1;
my $MIXED = 2;
my $UPPER = 3;

foreach my $base (1 .. 36) {
    $test {$base} [$PLAIN] = integer_tester -args => [-base => $base],
                                            -name => "-base => $base";

    next if $base <= 10;

    $test {$base} [$LOWER] = integer_tester -args => [-base => $base,
                                                      -case => "lower"],
                                            -name => "-base => $base, " .
                                                     "-case => 'lower'";

    $test {$base} [$MIXED] = integer_tester -args => [-base => $base,
                                                      -case => "mixed"],
                                            -name => "-base => $base, " .
                                                     "-case => 'mixed'";

    $test {$base} [$UPPER] = integer_tester -args => [-base => $base,
                                                      -case => "upper"],
                                            -name => "-base => $base, " .
                                                     "-case => 'upper'";
}

#
# Test characters matched
#
my $c = 0;
foreach my $base (1 .. 36) {
    $c ++;
    my $number    = substr $chars => 0, $base;
    my $sign      = $c & 1 ? "-" : "+";
    my $signed    = "$sign$number";
    my $lc_number = lc $number;
    my @todo      = $base <= 10 ? ($PLAIN) : ($PLAIN, $MIXED, $UPPER);
    foreach my $key (@todo) {
        $test {$base} [$key] -> match ($number,
                                        test     => "Basic number",
                                        captures => [[number     => $number],
                                                     [sign       => ''],
                                                     [abs_number => $number]]
        );

        $test {$base} [$key] -> match ("$sign$number",
                                         test     => "Basic signed number",
                                         captures => [[number     => $signed],
                                                      [sign       => $sign],
                                                      [abs_number => $number]]
        );
    }

    if ($base > 10) {
        foreach my $key ($MIXED, $LOWER) {
            $test {$base} [$key] ->
                    match ($lc_number,
                            test     => "Basic number, lower case",
                            captures => [[number     => $lc_number],
                                         [sign       => ''],
                                         [abs_number => $lc_number]]
            );
        }
    }

    #
    # Make sure '0' and a long string of '0's are matched.
    #
    my $zero  =  0;
    my $zeros = "0" x 100;
    @todo     = $base <= 10 ? ($PLAIN) : ($PLAIN, $LOWER, $MIXED, $UPPER);
    foreach my $key (@todo) {
        $test {$base} [$key] -> match ($zero,
                                        test     => "Zero",
                                        captures => [[number     => $zero],
                                                     [sign       => ''],
                                                     [abs_number => $zero]]
        );

        $test {$base} [$key] -> match ("+$zero",
                                        test     => "Positive zero",
                                        captures => [[number     => "+$zero"],
                                                     [sign       => '+'],
                                                     [abs_number => $zero]]
        );

        $test {$base} [$key] -> match ("-$zero",
                                        test     => "Negative zero",
                                        captures => [[number     => "-$zero"],
                                                     [sign       => '-'],
                                                     [abs_number => $zero]]
        );

        $test {$base} [$key] -> match ($zeros,
                                        test     => "Many zeros",
                                        captures => [[number     => $zeros],
                                                     [sign       => ''],
                                                     [abs_number => $zeros]]
        );
    }
}



Test::NoWarnings::had_no_warnings () if $r;

done_testing;
