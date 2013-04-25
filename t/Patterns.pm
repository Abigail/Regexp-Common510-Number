package t::Patterns;

use strict;

use Regexp::Common510 'Number';
use Exporter ();
use Test::Regexp 2013041801;

use warnings;
no  warnings 'syntax';

our @ISA    = qw [Exporter];
our @EXPORT = qw [$integer_default @integers];


our @integers = (
    our $integer_default    =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1),
         full_text          =>  1,
         name               => "Number integer",
         tags               => {-base => '10', -sign => ''},
    ),

    our $integer_plus       =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                                         -sign => '[+]'),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                                         -sign => '[+]'),
         full_text          =>  1,
         name               => "Number integer -sign => '[+]?'",
         tags               => {-base => '10', -sign => 'plus'},
    ),

    our $integer_minus      =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                                         -sign => '[-]'),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                                         -sign => '[-]'),
         full_text          =>  1,
         name               => "Number integer -sign => '[-]?'",
         tags               => {-base => '10', -sign => 'minus'},
    ),

    our $integer_unsigned   =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep     => 0,
                                                         -unsigned => 1),
         keep_pattern       =>  RE (Number => 'integer', -Keep     => 1,
                                                         -unsigned => 1),
         full_text          =>  1,
         name               => "Number integer -unsigned => 1",
         tags               => {-base => '10', -sign => 'unsigned'},
    ),

);
