#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my $base4  = decimal_tester -args => [-base =>  4],
                            -name => "Base 4";

my $base12 = decimal_tester -args => [-base => 12],
                            -name => "Base 12";

#
# Since the handling of base is very similar to the handling of base
# in integer patterns, we don't have a huge amount of tests
#

$base4 ->  match ("123.321",
                   test     => "Standard number",
                   captures => [[number     => "123.321"],
                                [sign       => ""],
                                [abs_number => "123.321"],
                                [integer    => "123"],
                                [radix      => "."],
                                [fraction   => "321"]]);

$base4 ->  no_match ("4321.1234",
                      reason => "Digits exceeding base");


$base12 -> match ("-123456789AB.BA987654321",
                   test     => "Standard number",
                   captures => [[number     => "-123456789AB.BA987654321"],
                                [sign       => "-"],
                                [abs_number => "123456789AB.BA987654321"],
                                [integer    => "123456789AB"],
                                [radix      => "."],
                                [fraction   => "BA987654321"]]);

$base12 -> no_match ("123456789ABC.1234",
                      reason => "Digits exceeding base");


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
