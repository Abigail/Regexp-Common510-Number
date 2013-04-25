#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Patterns;

our $r = eval "require Test::NoWarnings; 1";

my @test_4    = grep {$_ -> tag ('-base') eq  "4"} @integers;
my @test_10   = grep {$_ -> tag ('-base') eq "10"} @integers;
#
# Includes 'mixed'
#
my @test_30   = grep {$_ -> tag ('-base') eq "30" &&
                    (!$_ -> tag ('-case') || $_ -> tag ('-case') ne 'down')}
                      @integers;
my @test_30_l = grep {$_ -> tag ('-base') eq '30' &&
                      $_ -> tag ('-case') && ($_ -> tag ('-case') eq 'lower' ||
                                              $_ -> tag ('-case') eq 'mixed')}
                      @integers;

my @pass_4    = (0 .. 3, 10 .. 13, "3210" x 20);
my @fail_4    = (4 .. 9, 14, "123123112312391231231213");
my @pass_30   = (0 .. 9, "A" .. "T", "TSRQPONMLKJIHGFEDCBA9876543210");
my @pass_30_l = ("a" .. "t", "abcdefghijklmnopqrst");
my @fail_30   = ("U" .. "Z", "1234567ABCDEFLMNU0987654321");

foreach my $num (@pass_4) {
    my $integer = $num;

    foreach my $test (@test_4, @test_10, @test_30) {
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
    foreach my $test (@test_4, @test_10, @test_30) {
        if ($test -> tag ("-sign") eq ""     ||
            $test -> tag ("-sign") eq "plus" ||
            $test -> tag ("-sign") eq "signed") {
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
    foreach my $test (@test_4, @test_10, @test_30) {
        if ($test -> tag ("-sign") eq ""      ||
            $test -> tag ("-sign") eq "minus" ||
            $test -> tag ("-sign") eq "signed") {
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

foreach my $num (@fail_4) {
    foreach my $sign ("", "-", "+") {
        my $integer = "${sign}${num}";

        foreach my $test (@test_4) {
            $test -> no_match (
                $integer,
                reason => "Incorrect base"
            )
        }
    }
}



foreach my $num (@pass_30) {
    my $integer = $num;

    foreach my $test (@test_30) {
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
    foreach my $test (@test_30) {
        if ($test -> tag ("-sign") eq ""     ||
            $test -> tag ("-sign") eq "plus" ||
            $test -> tag ("-sign") eq "signed") {
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
    foreach my $test (@test_30) {
        if ($test -> tag ("-sign") eq ""      ||
            $test -> tag ("-sign") eq "minus" ||
            $test -> tag ("-sign") eq "signed") {
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

foreach my $num (@fail_30) {
    foreach my $sign ("", "-", "+") {
        my $integer = "${sign}${num}";

        foreach my $test (@test_30) {
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

        foreach my $test (@test_30_l) {
            $test -> match (
                $integer,
                test     => "Lower case",
                captures => [[number     => $integer],
                             [sign       => $sign],
                             [abs_number => $num]]
            );
        }
    }
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
