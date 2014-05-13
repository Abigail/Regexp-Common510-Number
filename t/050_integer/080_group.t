#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my  $pattern       = RE (Number => 'integer', -sep => ",",  -group => 3);
my  $keep_pattern  = RE (Number => 'integer', -sep  => ",", -group => 3,
                                              -Keep => 1);
my ($capture)      = $pattern      =~ /\(\?<(__RC_[^>]+)>/;
my ($keep_capture) = $keep_pattern =~ /\(\?<(__RC_[^>]+)>/;

my @data = (
    ["plain number"    => "0", "12", "000"],
    ["two groups"      => "1,234", "123,456"],
    ["multiple groups" => "1,234,567", "12,345,678,901,234"],
);

foreach my $entry (@data) {
    my ($test_name, @numbers) = @$entry;

    my $sep = $test_name =~ /^plain/ ? undef : ",";

    foreach my $number (@numbers) {
        my $signed = "-$number";

        match subject      => $number,
              name         => "Groups of three",
              keep_pattern => $pattern,
              captures     => [[$capture => $sep]],
              test         => $test_name,
              full_text    => 1;

        match subject      => $number,
              name         => "Groups of three, keeping",
              keep_pattern => $keep_pattern,
              captures     => [[number        => $number],
                               [sign          => ""],
                               [abs_number    => $number],
                               [$keep_capture => $sep],
                               [sep           => $sep],
                              ],
              test         => $test_name,
              full_text    => 1;

        #
        # With sign
        #
        match subject      => $signed,
              name         => "Groups of three",
              keep_pattern => $pattern,
              captures     => [[$capture => $sep]],
              test         => $test_name . ", with sign",
              full_text    => 1;

        match subject      => $signed,
              name         => "Groups of three, keeping",
              keep_pattern => $keep_pattern,
              captures     => [[number        => $signed],
                               [sign          => "-"],
                               [abs_number    => $number],
                               [$keep_capture => $sep],
                               [sep           => $sep],
                              ],
              test         => $test_name . ", with sign",
              full_text    => 1;
    }
}


 $pattern       = RE (Number => 'integer', -sep => ",",  -group => "2,5");
 $keep_pattern  = RE (Number => 'integer', -sep  => ",", -group => "2,5",
                                              -Keep => 1);
($capture)      = $pattern      =~ /\(\?<(__RC_[^>]+)>/;
($keep_capture) = $keep_pattern =~ /\(\?<(__RC_[^>]+)>/;


@data = (
    ["plain number"    => "0", "12", "000", "12345"],
    ["two groups"      => "1,23", "12,34567", "1234,56"],
    ["multiple groups" => "12,345,7890,12345,67"],
);


foreach my $entry (@data) {
    my ($test_name, @numbers) = @$entry;

    my $sep = $test_name =~ /^plain/ ? undef : ",";

    foreach my $number (@numbers) {
        my $signed = "-$number";

        match subject      => $number,
              name         => "Groups of two to five",
              keep_pattern => $pattern,
              captures     => [[$capture => $sep]],
              test         => $test_name,
              full_text    => 1;

        match subject      => $number,
              name         => "Groups of two to five, keeping",
              keep_pattern => $keep_pattern,
              captures     => [[number        => $number],
                               [sign          => ""],
                               [abs_number    => $number],
                               [$keep_capture => $sep],
                               [sep           => $sep],
                              ],
              test         => $test_name,
              full_text    => 1;

        #
        # With sign
        #
        match subject      => $signed,
              name         => "Groups of two to five",
              keep_pattern => $pattern,
              captures     => [[$capture => $sep]],
              test         => $test_name . ", with sign",
              full_text    => 1;

        match subject      => $signed,
              name         => "Groups of two to five, keeping",
              keep_pattern => $keep_pattern,
              captures     => [[number        => $signed],
                               [sign          => "-"],
                               [abs_number    => $number],
                               [$keep_capture => $sep],
                               [sep           => $sep],
                              ],
              test         => $test_name . ", with sign",
              full_text    => 1;
    }
}

#
# Does it default to using a comma separator?
#
my $comma_pat   = RE (Number => 'integer', -group => 3, -sep => ",");
my $default_pat = RE (Number => 'integer', -group => 3);

#
# Remove generated name, and compare
#
s/__RC_Number_\K[a-z_]+//g for $comma_pat, $default_pat;

is $default_pat, $comma_pat, "Pattern defaults to -sep => ','";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;

__END__
