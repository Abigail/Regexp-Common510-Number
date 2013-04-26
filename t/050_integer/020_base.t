#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Patterns;

our $r = eval "require Test::NoWarnings; 1";

my @pass_4    = (0 .. 3, 10 .. 13, "3210" x 20);
my @fail_4    = (4 .. 9, 14, "123123112312391231231213");
my @pass_30   = (0 .. 9, "A" .. "T", "TSRQPONMLKJIHGFEDCBA9876543210");
my @pass_30_l = ("a" .. "t", "abcdefghijklmnopqrst");
my @fail_30   = ("U" .. "Z", "1234567ABCDEFLMNU0987654321");

foreach my $num (@pass_4) {
    my $integer = $num;

    foreach my $test ($integer_4, $integer_default, $integer_unsigned,
                      $integer_30, $integer_30_mixed) {
        $test -> match (
            $integer,
            test     =>  "Unsigned integer",
            captures => [[number     => $integer],
                         [sign       => ""],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }
    foreach my $test ($integer_4_signed, $integer_plus, $integer_minus,
                      $integer_30_minus) {
        $test -> no_match (
            $integer,
            reason => "Unsigned integer"
        )
    }

    $integer = "+$num";
    foreach my $test ($integer_4, $integer_4_signed, $integer_default,
                      $integer_30, $integer_30_mixed) {
        $test -> match (
            $integer,
            test     =>  "Positive integer",
            captures => [[number     => $integer],
                         [sign       => "+"],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }
    foreach my $test ($integer_minus, $integer_30_minus) {
        $test -> no_match (
            $integer,
            reason => "Positive integer"
        )
    }

    $integer = "-$num";
    foreach my $test ($integer_4, $integer_4_signed, $integer_default,
                      $integer_minus, $integer_30, $integer_30_minus,
                      $integer_30_mixed) {
        $test -> match (
            $integer,
            test     =>  "Negative integer",
            captures => [[number     => $integer],
                         [sign       => "-"],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }
    foreach my $test ($integer_plus) {
        $test -> no_match (
            $integer,
            reason => "Negative integer"
        )
    }
}

foreach my $num (@fail_4) {
    foreach my $sign ("", "-", "+") {
        my $integer = "${sign}${num}";

        foreach my $test ($integer_4, $integer_4_signed) {
            $test -> no_match (
                $integer,
                reason => "Incorrect base"
            )
        }
    }
}



foreach my $num (@pass_30) {
    my $integer = $num;

    foreach my $test ($integer_30, $integer_30_mixed) {
        $test -> match (
            $integer,
            test     =>  "Unsigned integer",
            captures => [[number     => $integer],
                         [sign       => ""],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }
    foreach my $test ($integer_30_minus) {
        $test -> no_match (
            $integer,
            reason => "Unsigned integer"
        )
    }

    $integer = "+$num";
    foreach my $test ($integer_30, $integer_30_mixed) {
        $test -> match (
            $integer,
            test     =>  "Positive integer",
            captures => [[number     => $integer],
                         [sign       => "+"],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }

    $integer = "-$num";
    foreach my $test ($integer_30, $integer_30_minus, $integer_30_mixed) {
        $test -> match (
            $integer,
            test     =>  "Negative integer",
            captures => [[number     => $integer],
                         [sign       => "-"],
                         [prefix     => ""],
                         [abs_number => $num]],
        )
    }
}

foreach my $num (@fail_30) {
    foreach my $sign ("", "-", "+") {
        my $integer = "${sign}${num}";

        foreach my $test ($integer_30, $integer_30_minus, $integer_30_mixed,
                          $integer_30_down) {
            $test -> no_match (
                $integer,
                reason => "Incorrect base"
            )
        }
    }
}


for my $num (@pass_30_l) {
    foreach my $sign ("", "-", "+") {
        my $integer = "${sign}${num}";

        foreach my $test ($integer_30_mixed, $integer_30_down) {
            $test -> match (
                $integer,
                test     => "Lower case",
                captures => [[number     => $integer],
                             [sign       => $sign],
                             [prefix     => ""],
                             [abs_number => $num]]
            );
        }
    }
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
