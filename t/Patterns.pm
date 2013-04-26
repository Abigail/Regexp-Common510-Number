package t::Patterns;

use strict;

use Regexp::Common510 'Number';
use Exporter ();
use Test::Regexp 2013041801;

use warnings;
no  warnings 'syntax';

our @ISA    = qw [Exporter];
our @EXPORT = qw [$integer_default $integer_plus $integer_minus
                  $integer_unsigned $integer_4 $integer_4_signed 
                  $integer_30 $integer_30_minus $integer_30_mixed
                  $integer_30_down $integer_bin $integer_BiN $integer_BIN
                  $integer_oct $integer_OCT $integer_hex $integer_HeX
                  $integer_HEX
                  @integers];


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
         name               => "Number integer -sign => '[+]'",
         tags               => {-base => '10', -sign => 'plus'},
    ),

    our $integer_minus      =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                                         -sign => '[-]'),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                                         -sign => '[-]'),
         full_text          =>  1,
         name               => "Number integer -sign => '[-]'",
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

    our $integer_30_mixed   =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                    -case  => 'mixed',   -base => 30),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                    -case  => 'mixed',   -base => 30),
         full_text          =>  1,
         name               => "Number integer -base => 30 -case => 'mixed'",
         tags               => {-base => '30', -sign => '', -case => 'mixed'},
    ),

    our $integer_30_down    =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep => 0,
                                    -case  => 'down',    -base => 30),
         keep_pattern       =>  RE (Number => 'integer', -Keep => 1,
                                    -case  => 'down',    -base => 30),
         full_text          =>  1,
         name               => "Number integer -base => 30 -case => 'down'",
         tags               => {-base => '30', -sign => '', -case => 'down'},
    ),

    our $integer_bin        =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep =>  0,
                                                         -base => "bin"),
         keep_pattern       =>  RE (Number => 'integer', -Keep =>  1,
                                                         -base => "bin"),
         full_text          =>  1,
         name               => "Number integer -base => 'bin'",
         tags               => {-base => 'bin', -sign => ''},
    ),

    our $integer_BIN        =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep =>  0,
                                                         -base => "BIN"),
         keep_pattern       =>  RE (Number => 'integer', -Keep =>  1,
                                                         -base => "BIN"),
         full_text          =>  1,
         name               => "Number integer -base => 'BIN'",
         tags               => {-base => 'BIN', -sign => ''},
    ),

    our $integer_BiN        =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep =>  0,
                                                         -base => "BiN"),
         keep_pattern       =>  RE (Number => 'integer', -Keep =>  1,
                                                         -base => "BiN"),
         full_text          =>  1,
         name               => "Number integer -base => 'BiN'",
         tags               => {-base => 'BiN', -sign => ''},
    ),

    our $integer_oct        =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep =>  0,
                                                         -base => "oct"),
         keep_pattern       =>  RE (Number => 'integer', -Keep =>  1,
                                                         -base => "oct"),
         full_text          =>  1,
         name               => "Number integer -base => 'oct'",
         tags               => {-base => 'oct', -sign => ''},
    ),

    our $integer_OCT        =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep =>  0,
                                                         -base => "OCT"),
         keep_pattern       =>  RE (Number => 'integer', -Keep =>  1,
                                                         -base => "OCT"),
         full_text          =>  1,
         name               => "Number integer -base => 'OCT'",
         tags               => {-base => 'OCT', -sign => ''},
    ),

    our $integer_hex        =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep =>  0,
                                                         -base => "hex"),
         keep_pattern       =>  RE (Number => 'integer', -Keep =>  1,
                                                         -base => "hex"),
         full_text          =>  1,
         name               => "Number integer -base => 'hex'",
         tags               => {-base => 'hex', -sign => ''},
    ),

    our $integer_HEX        =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep =>  0,
                                                         -base => "HEX"),
         keep_pattern       =>  RE (Number => 'integer', -Keep =>  1,
                                                         -base => "HEX"),
         full_text          =>  1,
         name               => "Number integer -base => 'HEX'",
         tags               => {-base => 'HEX', -sign => ''},
    ),

    our $integer_HeX        =   Test::Regexp:: -> new -> init (
         pattern            =>  RE (Number => 'integer', -Keep =>  0,
                                                         -base => "HeX"),
         keep_pattern       =>  RE (Number => 'integer', -Keep =>  1,
                                                         -base => "HeX"),
         full_text          =>  1,
         name               => "Number integer -base => 'HeX'",
         tags               => {-base => 'HeX', -sign => ''},
    ),

);
