#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

#
# Tests without any options. Should match ASCII digital numbers,
# with, or without, a sign.
#
my $test = integer_tester;

#
# Sets of numbers to test.
#
my @test_sets = (
    ["Small integer" => [0 .. 100]],
    ["Integer"       => [123, "00", "0000000", 1234567890, 9999999999999999]],
    ["Huge integer"  => ["0987654321" x 40, "9" x 1000]],
);

foreach my $test_set (@test_sets) {
    my ($name, $set) = @$test_set;
    foreach my $number (@$set) {
        $test  -> match ($number,
                          test     => "$name",
                          captures => [[number      =>  $number],
                                       [sign        =>  ""],
                                       [abs_number  =>  $number]]);

        $test  -> match ("-$number",
                          test     => "$name, minus sign",
                          captures => [[number      =>  "-$number"],
                                       [sign        =>  "-"],
                                       [abs_number  =>  $number]]);

        $test  -> match ("+$number",
                          test     => "$name, plus sign",
                          captures => [[number      =>  "+$number"],
                                       [sign        =>  "+"],
                                       [abs_number  =>  $number]]);
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
