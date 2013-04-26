#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Patterns;

our $r = eval "require Test::NoWarnings; 1";

my @oct_p = ("0" .. "7", "77", "100", "12345670",
             "1365412371234100120126405" x 10);
my @oct_f = ("8" .. "9", "123456787654321");

foreach my $num (@oct_p) {
    #
    # No prefix; this ought to fail
    #
    foreach my $test ($integer_oct, $integer_OCT) {
        $test -> no_match (
            $num,
            reason => "No prefix",
        );
    }

    #
    # Prefix
    #
    my $number = "0$num";
    foreach my $test ($integer_oct, $integer_OCT) {
        $test -> match (
            $number,
            test     => "Prefix",
            captures => [[number     => $number],
                         [sign       => ""],
                         [prefix     => "0"],
                         [abs_number => $num]]
        );
    }

    #
    # Prefix with sign
    #
    $number = "-0$num";
    foreach my $test ($integer_oct, $integer_OCT) {
        $test -> match (
            $number,
            test     => "Prefix with sign",
            captures => [[number     => $number],
                         [sign       => "-"],
                         [prefix     => "0"],
                         [abs_number => $num]]
        );
    }
}

foreach my $num (@oct_f) {
    foreach my $prefix ("0") {
        foreach my $test ($integer_oct, $integer_OCT) {
            $test -> no_match (
                "${prefix}${num}",
                reason => "Incorrect base in numeric part"
            )
        }
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
