#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp 2013041801;

our $r = eval "require Test::NoWarnings; 1";

my %test;

my $chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

foreach my $base (2 .. 36) {
    $test {$base} [0] = Test::Regexp:: -> new -> init (
        pattern       =>  RE (Number => 'integer', -base => $base),
        keep_pattern  =>  RE (Number => 'integer', -base => $base, -Keep => 1),
        full_text     =>  1,
        name          => "Number integer: -base => $base",
    );

    $test {$base} [1] = Test::Regexp:: -> new -> init (
        pattern       =>  RE (Number => 'integer', -base => $base,
                                                   -case => "lower"),
        keep_pattern  =>  RE (Number => 'integer', -base => $base, -Keep => 1,
                                                   -case => "lower"),
        full_text     =>  1,
        name          => "Number integer: -base => $base",
    );
}

#
# Test characters matched
#
my $c = 0;
foreach my $base (2 .. 36) {
    $c ++;
    my $number = substr $chars => 0, $base;
    $test {$base} [0] -> match ($number,
                                test     => "Basic number",
                                captures => [[number     => $number],
                                             [sign       => ''],
                                             [prefix     => ''],
                                             [abs_number => $number]]
    );

    my $sign = $c & 1 ? "-" : "+";
    $test {$base} [0] -> match ("$sign$number",
                                test     => "Basic signed number",
                                captures => [[number     => "$sign$number"],
                                             [sign       => $sign],
                                             [prefix     => ''],
                                             [abs_number => $number]]
    );

    $test {$base} [1] -> match (lc $number,
                                test     => "Basic number, lower case",
                                captures => [[number     => lc $number],
                                             [sign       => ''],
                                             [prefix     => ''],
                                             [abs_number => lc $number]]
    );
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
