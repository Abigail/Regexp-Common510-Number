#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp 2013041801;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

#
# Testing for failures when using -prefix
#
no_match  pattern      => RE (Number => 'integer', -prefix => '0x'),
          keep_pattern => RE (Number => 'integer', -prefix => '0x', -Keep),
          name         => "Number integer: -prefix => 0x",
          subject      => '12345',
          reason       => "Prefix not present",
;

no_match  pattern      => RE (Number => 'integer', -prefix => '9'),
          keep_pattern => RE (Number => 'integer', -prefix => '9', -Keep),
          name         => "Number integer: -prefix => 9",
          subject      => '9',
          reason       => "Only prefix",
;


no_match  pattern      => RE (Number => 'integer', -prefix => '0x'),
          keep_pattern => RE (Number => 'integer', -prefix => '0x', -Keep),
          name         => "Number integer: -prefix => 0x",
          subject      => '',
          reason       => "Empty string",
;

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
