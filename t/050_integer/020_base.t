#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Patterns;

our $r = eval "require Test::NoWarnings; 1";

my @test_4  = grep {$_ -> tag ('-base') eq  "4"} @integers;
my @test_10 = grep {$_ -> tag ('-base') eq "10"} @integers;
my @test_30 = grep {$_ -> tag ('-base') eq "30"} @integers;

my @pass_4  = (0 .. 3, 10 .. 13, "3210" x 20);
my @fail_4  = (4 .. 9, 14, "123123112312391231231213");
my @pass_30 = (0 .. 9, "A" .. "T", "TSRQPONMLKJIHGFEDCBA9876543210");
my @fail_30 = ("U" .. "Z", "1234567ABCDEFLMNU0987654321");

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

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
