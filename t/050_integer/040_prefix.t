#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp;

our $r = eval "require Test::NoWarnings; 1";

my @numbers  = ("0", "9", "01234", "1091243570192345091457019850219345109851");
my @prefixes = ("!#%", " ", "-", "+");

foreach my $prefix (@prefixes) {
    my $prefix_pat = $prefix eq '+' ? "[$prefix]" : $prefix;
    my $test = Test::Regexp:: -> new -> init (
        pattern      => RE (Number => 'integer', -prefix => $prefix_pat,
                                                 -Keep   => 0),
        keep_pattern => RE (Number => 'integer', -prefix => $prefix_pat,
                                                 -Keep   => 1),
        full_text    => 1,
        name         => "Number integer -prefix => '$prefix_pat'"
    );

    foreach my $num (@numbers) {
        foreach my $sign ("", "-", "+") {
            my $number = "${sign}${prefix}${num}";
            $test -> match (
                $number,
                test     => $sign ? "Prefix '$prefix'" 
                                  : "Prefix '$prefix', with sign '$sign'",
                captures => [[number     => $number],
                             [sign       => $sign],
                             [prefix     => $prefix],
                             [abs_number => $num]],
            );
        }
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
