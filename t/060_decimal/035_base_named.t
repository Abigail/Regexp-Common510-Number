#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

#
# Testing named bases, lower case
#

#
# Various patterns
#
my %pattern_args = (
    "2"  => ["-base => bin"  =>  -base => 'bin'],
    "8"  => ["-base => oct"  =>  -base => 'oct'],
   "16"  => ["-base => hex"  =>  -base => 'hex'],
    "2^" => ["-base => BIN"  =>  -base => 'BIN'],
    "8^" => ["-base => OCT"  =>  -base => 'OCT'],
   "16^" => ["-base => HEX"  =>  -base => 'HEX'],
);

my %test;
foreach my $key (keys %pattern_args) {
    my ($name, @args) = @{$pattern_args {$key}};

    $test {$key} = decimal_tester -args => \@args,
                                  -name => $name;
}

my %numbers;
$numbers  {2} = ["0", "0.1", ".1100110", "01011011.", "10011.11000101111"];
$numbers  {8} = ["2", "6.7", ".2561624", "10431742.", "7326317.011011134"];
$numbers {16} = ["0", "a.b", ".921ad81", "abef11d5.", "1ab19ff4c.d2ef125"];

my %prefixes = (2 => '0b', 8 => '0', 16 => '0x');

my $c = 0;

foreach my $base (2, 8, 16) {
    my $prefix   = $prefixes {$base};

    foreach my $number (@{$numbers {$base}}) {
        $c ++;
        my $prefixed      = "$prefix$number";
        my $sign          = $c & 1 ? "+" : "-";
        my $signed        = "$sign$number";
        my $prefix_signed = "$sign$prefix$number";
        my ($integer, $fraction, $radix);
        if ($number =~ /[.]/p) {
            $integer  = ${^PREMATCH};
            $fraction = ${^POSTMATCH};
            $radix    = ".";
        }
        else {
            $integer = $number;
        }

        #
        # Test both upper and lower case
        #
        foreach my $key ($base, "$base^") {
            my $number        = $key =~ /\^$/ ? uc $number   : $number;
            my $signed        = $key =~ /\^$/ ? uc $signed   : $signed;
            my $prefixed      = $key =~ /\^$/ ? uc $prefixed : $prefixed;
            my $prefix_signed = $key =~ /\^$/ ? uc $prefix_signed
                                              :    $prefix_signed;
            my $prefix        = $key =~ /\^$/ ? uc $prefix   : $prefix;
            my $integer       = $key =~ /\^$/ ? uc $integer  : $integer;
            my $fraction      = defined $fraction && $key =~ /\^$/
                                              ? uc $fraction : $fraction;

            my @captures = (
                [abs_number => $number],
                [integer    => $integer],
                [radix      => $radix],
                [fraction   => $fraction],
            );

            $test {$key} -> match ($number, 
                                    test     =>  "Plain number",
                                    captures =>  [[number     => $number],
                                                  [sign       => ''],
                                                  [prefix     => ''],
                                                  @captures,
                                                 ],
            );

            $test {$key} -> match ($signed, 
                                    test     =>  "Signed number",
                                    captures =>  [[number     => $signed],
                                                  [sign       => $sign],
                                                  [prefix     => ''],
                                                  @captures,
                                                 ],
            );

            #
            # Test with prefix
            #
            $test {$key} -> match ($prefixed, 
                                    test     =>  "Prefixed number",
                                    captures =>  [[number     => $prefixed],
                                                  [sign       => ''],
                                                  [prefix     => $prefix],
                                                  @captures,
                                                 ],
            );

            #
            # ... and a sign
            #
            $test {$key} -> match ($prefix_signed, 
                                    test     =>  "Signed prefixed number",
                                    captures => [[number     => $prefix_signed],
                                                 [sign       => $sign],
                                                 [prefix     => $prefix],
                                                 @captures,
                                                 ],
            );
        }
    }
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
