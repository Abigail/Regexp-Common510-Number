#!/usr/bin/perl

use 5.010;

use strict;

use Test::More 0.88;

BEGIN {
    eval "use Test::Warn; 1" or 
          plan skip_all => "Test::Warn required for testing warnings";
}

our $r = eval "require Test::NoWarnings; 1";

use Regexp::Common510 'Number';

use warnings;
no  warnings 'syntax';

warning_like
    {RE Number => "integer", -base => '8', -case => 'lower'}
     qr /-case is used, but -base does not exceed 10; -case setting is ignored/,
    "Warn on -case used with low -base";

warning_like
    {RE Number => "integer", -case => 'lower'}
     qr /-case is used, but -base does not exceed 10; -case setting is ignored/,
    "Warn on -case used without -base";

#
# This should not warn.
#
RE Number => "integer", -base => '12', -case => 'lower';

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
