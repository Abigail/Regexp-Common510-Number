#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my $test_comma = integer_tester -args => [-sep => ","],
                                -name => "Comma separator";

my $test_mixed = integer_tester -args => [-sep => "[,.]"],
                                -name => "Mixed separator";

$test_comma -> no_match ("",       reason => "Empty string");
$test_comma -> no_match (",123",   reason => "No digits before separator");
$test_comma -> no_match ("-,123",  reason => "No digits before separator");
$test_comma -> no_match ("123,",   reason => "No digits after separator");
$test_comma -> no_match ("12,,34", reason => "Multiple successive separators");
$test_comma -> no_match ("12.34",  reason => "Incorrect separator");

$test_mixed -> no_match ("1.2,3",  reason => "Different separators");


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
