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


my $test = decimal_tester;

use charnames ":full";

#
# Failures
#
$test -> no_match ("",
                    reason => "Empty string");
$test -> no_match (" ",
                    reason => "Space");
$test -> no_match (".",
                    reason => "Only a radix point");
$test -> no_match (" 12.34",
                    reason => "Leading space");
$test -> no_match ("1.234 ",
                    reason => "Trailing space");
$test -> no_match ("123.4\n",
                    reason => "Trailing newline");
$test -> no_match ("12.34.56",
                    reason => "More than one radix point");


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
