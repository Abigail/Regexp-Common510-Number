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
    foreach my $sign ("", "-", "+") {
        my $test_name = $sign eq '-' ? "Negative number"
                      : $sign eq '+' ? "Positive number"
                      :                "Unsigned number";
        my $integer = "${sign}${num}";
        foreach my $test ($integer_default) {
            $test -> match (
                $integer,
                test     =>  $test_name,
                captures => [[number     => $integer],
                             [sign       => $sign],
                             [abs_number => $num]],
            )
        }
    }
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
