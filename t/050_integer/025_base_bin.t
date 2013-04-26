#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Patterns;

our $r = eval "require Test::NoWarnings; 1";

my @bin_p = ("0", "1", "01", "10", "11", "00",
             "10011110100101101010110110" x 10);
my @bin_f = ("2" .. "9", "101010110201010");

foreach my $num (@bin_p) {
    #
    # No prefix; this ought to fail
    #
    foreach my $test ($integer_bin, $integer_BIN, $integer_BiN) {
        $test -> no_match (
            $num,
            reason => "No prefix",
        );
    }

    #
    # Lower case prefix
    #
    my $number = "0b$num";
    foreach my $test ($integer_bin, $integer_BiN) {
        $test -> match (
            $number,
            test     => "Lowercase prefix",
            captures => [[number     => $number],
                         [sign       => ""],
                         [prefix     => "0b"],
                         [abs_number => $num]]
        );
    }
    foreach my $test ($integer_BIN) {
        $test -> no_match (
            $number,
            reason => "Lowercase prefix",
        );
    }

    #
    # Upper case prefix
    #
    $number = "0B$num";
    foreach my $test ($integer_BIN, $integer_BiN) {
        $test -> match (
            $number,
            test     => "Uppercase prefix",
            captures => [[number     => $number],
                         [sign       => ""],
                         [prefix     => "0B"],
                         [abs_number => $num]]
        );
    }
    foreach my $test ($integer_bin) {
        $test -> no_match (
            $number,
            reason => "Uppercase prefix",
        );
    }

    #
    # Lower case prefix with sign
    #
    $number = "-0b$num";
    foreach my $test ($integer_bin, $integer_BiN) {
        $test -> match (
            $number,
            test     => "Lowercase prefix with sign",
            captures => [[number     => $number],
                         [sign       => "-"],
                         [prefix     => "0b"],
                         [abs_number => $num]]
        );
    }
    foreach my $test ($integer_BIN) {
        $test -> no_match (
            $number,
            reason => "Lowercase prefix",
        );
    }
}

foreach my $num (@bin_f) {
    foreach my $prefix ("0b", "0B") {
        foreach my $test ($integer_bin, $integer_BiN, $integer_BIN) {
            $test -> no_match (
                "${prefix}${num}",
                reason => "Incorrect base in numeric part"
            )
        }
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
