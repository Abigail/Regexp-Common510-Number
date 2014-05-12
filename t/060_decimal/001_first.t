#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

ok "123456.7890" =~ RE (Number => 'decimal'), "Decimal";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
