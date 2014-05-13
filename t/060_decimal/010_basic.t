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
# Tests without any options. Should match ASCII decimal numbers,
# with, or without, a sign.
#
my $test = decimal_tester;

#
# Sets of numbers to test.
#
my @test_sets = (
    ["Small decimals" => ["0.1", "123.24", "78.00", "0000.1"]],
    ["Integer"        => ["0", "00", "123456789"]],
    ["Leading radix"  => [".0", ".1234567890"]],
    ["Trailing radix" => ["0.", "123456789."]],
);

foreach my $test_set (@test_sets) {
    my ($name, $set) = @$test_set;
    my $radix = $name eq 'Integer' ? undef : ".";
    foreach my $number (@$set) {
        my ($integer, $fraction) = split /[.]/ => $number;
        $test  -> match ($number,
                          test     => "$name",
                          captures => [[number      =>  $number],
                                       [sign        =>  ""],
                                       [abs_number  =>  $number],
                                       [integer     =>  $integer],
                                       [radix       =>  $radix],
                                       [fraction    =>  $fraction],
                                      ]);

        $test  -> match ("-$number",
                          test     => "$name, minus sign",
                          captures => [[number      =>  "-$number"],
                                       [sign        =>  "-"],
                                       [abs_number  =>  $number],
                                       [integer     =>  $integer],
                                       [radix       =>  $radix],
                                       [fraction    =>  $fraction],
                                      ]);

        $test  -> match ("+$number",
                          test     => "$name, plus sign",
                          captures => [[number      =>  "+$number"],
                                       [sign        =>  "+"],
                                       [abs_number  =>  $number],
                                       [integer     =>  $integer],
                                       [radix       =>  $radix],
                                       [fraction    =>  $fraction],
                                      ]);
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
