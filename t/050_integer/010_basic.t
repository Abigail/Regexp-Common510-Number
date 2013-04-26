#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Patterns;

our $r = eval "require Test::NoWarnings; 1";

my @special = (123456789, "00", "000000000000000000", "000001230000",
               "9876543210" x 100);

foreach my $num (0 .. 100, @special) {
    my $integer = $num;

    #
    # Test matching unsigned integers
    #
    foreach my $test ($integer_default, $integer_unsigned) {
        $test -> match (
            $integer,
            test     =>  "Unsigned integer",
            captures => [[number     => $integer],
                         [sign       => ""],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }

    foreach my $test ($integer_plus, $integer_minus) {
        $test -> no_match (
            $integer,
            reason => "Unsigned integer"
        )
    }

    #
    # Test matching positive integers
    #
    $integer = "+$num";
    foreach my $test ($integer_default, $integer_plus) {
        $test -> match (
            $integer,
            test     =>  "Positive integer",
            captures => [[number     => $integer],
                         [sign       => "+"],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }

    foreach my $test ($integer_unsigned, $integer_minus) {
        $test -> no_match (
            $integer,
            reason => "Positive integer"
        )
    }

    #
    # Test matching negative integers
    #
    $integer = "-$num";
    foreach my $test ($integer_default, $integer_minus) {
        $test -> match (
            $integer,
            test     =>  "Negative integer",
            captures => [[number     => $integer],
                         [sign       => "-"],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }
    foreach my $test ($integer_unsigned, $integer_plus) {
        $test -> no_match (
            $integer,
            reason => "Negative integer"
        )
    }
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
