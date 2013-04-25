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

my @tests = grep {$_ -> tag ('-base') eq "10"} @integers;

foreach my $num (0 .. 100, @special) {
    my $integer = $num;

    foreach my $test (@tests) {
        if ($test -> tag ("-sign") eq "" ||
            $test -> tag ("-sign") eq "unsigned") {
            $test -> match (
                $integer,
                test     =>  "Unsigned integer",
                captures => [[number     => $integer],
                             [sign       => ""],
                             [abs_number => $num]],
            )
        }
        else {
            $test -> no_match (
                $integer,
                reason => "Unsigned integer"
            )
        }
    }

    $integer = "+$num";
    foreach my $test (@tests) {
        if ($test -> tag ("-sign") eq "" || $test -> tag ("-sign") eq "plus") {
            $test -> match (
                $integer,
                test     =>  "Positive integer",
                captures => [[number     => $integer],
                             [sign       => "+"],
                             [abs_number => $num]],
            )
        }
        else {
            $test -> no_match (
                $integer,
                reason => "Positive integer"
            )
        }
    }

    $integer = "-$num";
    foreach my $test (@tests) {
        if ($test -> tag ("-sign") eq "" || $test -> tag ("-sign") eq "minus") {
            $test -> match (
                $integer,
                test     =>  "Negative integer",
                captures => [[number     => $integer],
                             [sign       => "-"],
                             [abs_number => $num]],
            )
        }
        else {
            $test -> no_match (
                $integer,
                reason => "Negative integer"
            )
        }
    }

}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
