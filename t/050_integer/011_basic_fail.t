#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use warnings 'Regexp::Common510';

our $r = eval "require Test::NoWarnings; 1";

#
# Tests without any options. Should match ASCII digital numbers,
# with, or without, a sign.
#

my $test = integer_tester;


use charnames ":full";

#
# Failures
#
$test -> no_match ("",
                   reason => "Empty string");
$test -> no_match (" ",
                   reason => "Space");
$test -> no_match (" 1234",
                   reason => "Leading space");
$test -> no_match ("1234 ",
                   reason => "Trailing space");
$test -> no_match ("1234\n",
                   reason => "Trailing newline");
$test -> no_match ("- 1234",
                   reason => "Space after sign");
$test -> no_match ("+ 1234",
                   reason => "Space after sign");
$test -> no_match ("123,456",
                   reason => "Number contains groups");
$test -> no_match ("123.456",
                   reason => "Number has decimal point");
$test -> no_match ("123.",
                   reason => "Number has trailing decimal point");
$test -> no_match ("1\N{BENGALI DIGIT TWO}3",
                   reason => "Contains non-ASCII digit");
$test -> no_match ("\N{NKO DIGIT ONE}\N{NKO DIGIT TWO}\N{NKO DIGIT THREE}",
                   reason => "Contains non-ASCII digits");
$test -> no_match ("123A",
                   reason => "Digits exceeding base");
$test -> no_match ("ABCDEF",
                   reason => "Digits exceeding base");
$test -> no_match ("0x123",
                   reason => "Number has a prefix");
$test -> no_match ("0b123",
                   reason => "Number has a prefix");


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
