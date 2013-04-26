#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Patterns;

our $r = eval "require Test::NoWarnings; 1";

my @hex_p = ("0" .. "9", "a" .. "f", "0a", "a0", "ff", "00",
             "123875af713feac9123def1239092143" x 10);
my @hex_f = ("g" .. "z", "913298adel391fed");

foreach my $num (@hex_p) {
    #
    # No prefix; this ought to fail
    #
    foreach my $test ($integer_hex, $integer_HEX, $integer_HeX) {
        $test -> no_match (
            $num,
            reason => "No prefix",
        );
    }

    #
    # Lower case prefix
    #
    my $number = "0x$num";
    foreach my $test ($integer_hex, $integer_HeX) {
        $test -> match (
            $number,
            test     => "Lowercase prefix",
            captures => [[number     => $number],
                         [sign       => ""],
                         [prefix     => "0x"],
                         [abs_number => $num]]
        );
    }
    foreach my $test ($integer_HEX) {
        $test -> no_match (
            $number,
            reason => "Lowercase prefix",
        );
    }

    #
    # Upper case prefix
    #
    $number = "0X\U$num";
    foreach my $test ($integer_HEX, $integer_HeX) {
        $test -> match (
            $number,
            test     => "Uppercase prefix",
            captures => [[number     => $number],
                         [sign       => ""],
                         [prefix     => "0X"],
                         [abs_number => uc $num]]
        );
    }
    foreach my $test ($integer_hex) {
        $test -> no_match (
            $number,
            reason => "Uppercase prefix",
        );
    }

    #
    # Lower case prefix with sign
    #
    $number = "-0x$num";
    foreach my $test ($integer_hex, $integer_HeX) {
        $test -> match (
            $number,
            test     => "Lowercase prefix with sign",
            captures => [[number     => $number],
                         [sign       => "-"],
                         [prefix     => "0x"],
                         [abs_number => $num]]
        );
    }
    foreach my $test ($integer_HEX) {
        $test -> no_match (
            $number,
            reason => "Lowercase prefix",
        );
    }
}

foreach my $num (@hex_f) {
    foreach my $prefix ("0x", "0X") {
        foreach my $test ($integer_hex, $integer_HeX, $integer_HEX) {
            $test -> no_match (
                "${prefix}${num}",
                reason => "Incorrect base in numeric part"
            )
        }
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
