#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my @numbers  = ("0.", ".9", "012.34",
                "1091243570192345091457.019850219345109851");
my @prefixes = ("!#%", " ", "-", "+");

foreach my $prefix (@prefixes) {
    my $prefix_pat = $prefix eq '+' ? "[$prefix]" : $prefix;
    my $test = decimal_tester -args => [-prefix =>  $prefix_pat],
                              -name => "-prefix => /$prefix_pat/";

    foreach my $num (@numbers) {
        my ($integer, $fraction) = split /[.]/ => $num;
        foreach my $sign ("", "-", "+") {
            my $number = "${sign}${prefix}${num}";
            $test -> match (
                $number,
                test     => $sign ? "Prefix '$prefix'" 
                                  : "Prefix '$prefix', with sign '$sign'",
                captures => [[number     => $number],
                             [sign       => $sign],
                             [prefix     => $prefix],
                             [abs_number => $num],
                             [integer    => $integer],
                             [radix      => '.'],
                             [fraction   => $fraction]],
            );
        }
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
