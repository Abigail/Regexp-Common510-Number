#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my  $comma_pat       = RE (Number => 'integer', -sep => ",");
my  $comma_pat_keep  = RE (Number => 'integer', -sep => ",", -Keep => 1);
my ($comma_cap)      = $comma_pat      =~ /\(\?<(__RC_[^>]+)>/;
my ($comma_cap_keep) = $comma_pat_keep =~ /\(\?<(__RC_[^>]+)>/;

my  $dot_pat         = RE (Number => 'integer', -sep => ".");
my  $dot_pat_keep    = RE (Number => 'integer', -sep => ".", -Keep => 1);
my ($dot_cap)        = $dot_pat        =~ /\(\?<(__RC_[^>]+)>/;
my ($dot_cap_keep)   = $dot_pat_keep   =~ /\(\?<(__RC_[^>]+)>/;

my  $mixed_pat       = RE (Number => 'integer', -sep => "[,.]");
my  $mixed_pat_keep  = RE (Number => 'integer', -sep => "[,.]", -Keep => 1);
my ($mixed_cap)      = $mixed_pat      =~ /\(\?<(__RC_[^>]+)>/;
my ($mixed_cap_keep) = $mixed_pat_keep =~ /\(\?<(__RC_[^>]+)>/;

my @data = (
    ["plain number"        =>  "0", "123"],
    ["single separator"    =>  "123,456", "0,0", "9,876543210"],
    ["multiple separators" =>  "123,456,789", "1,2,3,4,5,6,7,8,9"],
);

foreach my $test (@data) {
    my ($name, @numbers) = @$test;
    my  $csep = $name =~ /plain/ ? undef : ",";
    my  $dsep = $name =~ /plain/ ? undef : ".";

    foreach my $number (@numbers) {
        my $signed = "+$number";
        my $dotted = $number; $dotted =~ s/,/./g;

        match subject      => $number,
              keep_pattern => $comma_pat,
              captures     => [[$comma_cap => $csep]],
              name         => "Comma separator",
              test         => $name;

        match subject      => $number,
              keep_pattern => $comma_pat_keep,
              captures     => [[number          => $number],
                               [sign            => ""],
                               [abs_number      => $number],
                               [$comma_cap_keep => $csep],
                               [sep             => $csep],
                              ],
              name         => "Comma separator, keeping",
              test         => $name;

        #
        # Mix with signs
        #
        match subject      => $signed,
              keep_pattern => $comma_pat,
              captures     => [[$comma_cap => $csep]],
              name         => "Comma separator",
              test         => $name;

        match subject      => $signed,
              keep_pattern => $comma_pat_keep,
              captures     => [[number          => $signed],
                               [sign            => "+"],
                               [abs_number      => $number],
                               [$comma_cap_keep => $csep],
                               [sep             => $csep],
                              ],
              name         => "Comma separator, keeping",
              test         => $name;

        #
        # Test with a dot separator
        #
        match subject      => $dotted,
              keep_pattern => $dot_pat,
              captures     => [[$dot_cap   => $dsep]],
              name         => "Dot separator",
              test         => $name;

        match subject      => $dotted,
              keep_pattern => $dot_pat_keep,
              captures     => [[number          => $dotted],
                               [sign            => ""],
                               [abs_number      => $dotted],
                               [$dot_cap_keep   => $dsep],
                               [sep             => $dsep],
                              ],
              name         => "Dot separator, keeping",
              test         => $name;


        #
        # A separator allowing both commas and dots should match either
        #
        match subject      => $number,
              keep_pattern => $mixed_pat,
              captures     => [[$mixed_cap => $csep]],
              name         => "Mixed separator",
              test         => $name;

        match subject      => $number,
              keep_pattern => $mixed_pat_keep,
              captures     => [[number          => $number],
                               [sign            => ""],
                               [abs_number      => $number],
                               [$mixed_cap_keep => $csep],
                               [sep             => $csep],
                              ],
              name         => "Mixed separator, keeping",
              test         => $name;


        match subject      => $dotted,
              keep_pattern => $mixed_pat,
              captures     => [[$mixed_cap   => $dsep]],
              name         => "Mixed separator",
              test         => $name;

        match subject      => $dotted,
              keep_pattern => $mixed_pat_keep,
              captures     => [[number          => $dotted],
                               [sign            => ""],
                               [abs_number      => $dotted],
                               [$mixed_cap_keep => $dsep],
                               [sep             => $dsep],
                              ],
              name         => "Mixed separator, keeping",
              test         => $name;
    }
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;


__END__
