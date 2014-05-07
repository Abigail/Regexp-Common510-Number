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

#
# Testing for failures when setting a base.
#

my %test;

my $chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

my $PLAIN = 0;
my $LOWER = 1;
my $MIXED = 2;
my $UPPER = 3;

my @BASES = (1 .. 36);
my @CASES = ($PLAIN, $LOWER, $MIXED, $UPPER);

foreach my $base (@BASES) {
    $test {$base} [$PLAIN] = integer_tester -args => [-base =>  $base],
                                            -name => "-base => '$base'";

    next unless $base > 10;

    $test {$base} [$LOWER] = integer_tester -args => [-base =>  $base,
                                                      -case => "lower"],
                                            -name => "-base => '$base', " .
                                                     "-case => 'lower'";

    $test {$base} [$MIXED] = integer_tester -args => [-base =>  $base,
                                                      -case => "mixed"],
                                            -name => "-base => '$base', " .
                                                     "-case => 'mixed'";

    $test {$base} [$UPPER] = integer_tester -args => [-base =>  $base,
                                                      -case => "upper"],
                                            -name => "-base => '$base', " .
                                                     "-case => 'upper'";
}


#
# Empty string should never match
#
foreach my $base (@BASES) {
    #
    # Empty string
    #
    foreach my $case (@CASES) {
        next if $base <= 10 && $case != $PLAIN;
        $test {$base} [$case] -> no_match ("", reason => "Empty string");
    }

    #
    # Digits exceeding base
    #
    unless ($base == $BASES [-1]) {
        my @numbers = (substr ($chars, 0, $base + 1),
                       substr ($chars, $base, 1));
        foreach my $number (@numbers) {
            $test {$base} [$PLAIN] -> no_match ($number, reason =>
                                                        "Digits exceeding base")
        }
    }

    #
    # Flip the case
    #
    if ($base > 10) {
        my $uc_number = substr ($chars, $base - 1, 1);
        my $lc_number = lc $uc_number;
        my $mc_number = $uc_number . $lc_number;

        foreach my $case ($PLAIN, $UPPER) {
            my $test = $test {$base} [$case];
            $test -> no_match ($lc_number, reason => "Number in lower case");
            $test -> no_match ($mc_number, reason => "Number in mixed case");
        }
        foreach my $case ($LOWER) {
            my $test = $test {$base} [$case];
            $test -> no_match ($uc_number, reason => "Number in upper case");
            $test -> no_match ($mc_number, reason => "Number in mixed case");
        }
    }

    my $number = substr ($chars, 0, $base);

    #
    # Trailing/leading garbage
    #
    foreach my $case (@CASES) {
        next if $base <= 10 && $case != $PLAIN;
        my $test = $test {$base} [$case];
        $test -> no_match ("$number\n",         reason => "Trailing newline");
        $test -> no_match (" $number",          reason => "Leading space");
        $test -> no_match ("$number.",          reason => "Trailing decimal " .
                                                          "point");
        $test -> no_match ("$number\0",         reason => "Trailing NUL");
        $test -> no_match ("This is nonsense!", reason => "Nonsense");
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
