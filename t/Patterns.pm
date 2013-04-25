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

    our $integer_4          =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                                         -base => 4),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                                         -base => 4),
         full_text          =>  1,
         name               => "Number integer -base => 4",
         tags               => {-base => '4', -sign => ''},
    ),

    our $integer_4_signed   =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                   -base   => 4,         -sign => '[-+]'),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                   -base   => 4,         -sign => '[-+]'),
         full_text          =>  1,
         name               => "Number integer -base => 4",
         tags               => {-base => '4', -sign => 'signed'},
    ),

    our $integer_30         =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                                         -base => 30),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                                         -base => 30),
         full_text          =>  1,
         name               => "Number integer -base => 30",
         tags               => {-base => '30', -sign => ''},
    ),

    our $integer_30_minus   =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                   -base   => 30,        -sign => '-'),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                   -base   => 30,        -sign => '-'),
         full_text          =>  1,
         name               => "Number integer -base => 30",
         tags               => {-base => '30', -sign => 'minus'},
    ),
);
