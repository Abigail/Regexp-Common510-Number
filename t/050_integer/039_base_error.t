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

throws_ok {RE Number => "integer", -base => 0}
          qr /^-base must be an unsigned integer between 1 and 36 inclusive/,
          "Croaks on zero -base";

throws_ok {RE Number => "integer", -base => -5}
          qr /^-base must be an unsigned integer between 1 and 36 inclusive/,
          "Croaks on negative -base";

throws_ok {RE Number => "integer", -base => 37}
          qr /^-base must be an unsigned integer between 1 and 36 inclusive/,
          "Croaks on -base exceeding 36";

throws_ok {RE Number => "integer", -base => ' '}
          qr /^-base must be an unsigned integer between 1 and 36 inclusive/,
          "Croaks on -base not a number";

throws_ok {RE Number => "integer", -base => '8', -case => 'foo'}
          qr /^-case should be one of 'upper', 'lower' or 'mixed'/,
          "Croaks on illegal -case";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
