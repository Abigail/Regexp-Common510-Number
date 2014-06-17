#!/usr/bin/perl

use 5.010;

use strict;

use Test::More 0.88;

BEGIN {
    eval "use Test::Exception; 1" or 
          plan skip_all => "Test::Exception required for testing exceptions";
}

our $r = eval "require Test::NoWarnings; 1";

use Regexp::Common510 'Number';

use warnings;
no  warnings 'syntax';

throws_ok {RE Number => "decimal", -chars => '012345', -base => 8}
          qr /^-base must be an unsigned integer between 1 and 6 inclusive/,
          "Croaks on -base size exceeding -chars length";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
