#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

ok "1234567890" =~ RE (Number => 'integer'), "Integer";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
