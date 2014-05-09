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

throws_ok {RE Number => "integer", -sep => ",", -group => "8,3"}
          qr /Can't do -group => n,m with n > m/,
          "Croaks on reversed -group";

throws_ok {RE Number => "integer", -sep => ",", -group => "foo"}
          qr /Don't know what to do with '-group => foo'/,
          "Croaks on nonsense -group";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
