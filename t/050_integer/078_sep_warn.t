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
use Test::Regexp;

use warnings;
no  warnings 'syntax';

my $match = "You cannot have -places if you also have -sep, " .
            "or a -group; ignoring the -places parameter";

my $pattern;
warning_like
    {$pattern = RE Number => "integer", -sep => ",", -places => 3}
     qr /$match/,
    "Warn if -sep and -places are used together";

my ($capture) = $pattern =~ /\(\?<(__RC_[^>]+)>/;

match keep_pattern => $pattern,
      name         => "-places ignored",
      subject      => "12345",
      captures     => [[$capture => undef]];


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
