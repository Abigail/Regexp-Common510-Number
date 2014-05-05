#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp 2013041801;

our $r = eval "require Test::NoWarnings; 1";

#
# Testing named bases, lower case
#

#
# Various patterns
#
my %pattern_args = (
    "2"  => ["-base = bin"  =>  -base => 'bin'],
    "8"  => ["-base = oct"  =>  -base => 'oct'],
   "16"  => ["-base = hex"  =>  -base => 'hex'],
    "2^" => ["-base = BIN"  =>  -base => 'BIN'],
    "8^" => ["-base = OCT"  =>  -base => 'OCT'],
   "16^" => ["-base = HEX"  =>  -base => 'HEX'],
);

my %test;
foreach my $key (keys %pattern_args) {
    my ($name, @args) = @{$pattern_args {$key}};

    $test {$key} = Test::Regexp:: -> new -> init (
        pattern      => RE (Number => "integer", @args),
        keep_pattern => RE (Number => "integer", @args, -Keep => 1),
        full_text    => 1,
        name         => "Number integer: $name",
    );
}

my %numbers;
$numbers  {2} = ["0", "1", "00", "11", "010010100101", "0" x 40];
$numbers  {8} = ["0" .. "7", "00", "01234567", "25172346117651234712",
                                     "76543210" x 40];
$numbers {16} = ["0" .. "9", "a" .. "f", "00", "0123456789abcdef", 
                                     "187abe892eef125b6c6a6b89e",
                                     "fedcba9876543210" x 40];

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

        #
        # Tricky: if a number starts with a 0, octal patterns will think
        # it starts with a prefix, so don't test those.
        #
        unless ($base == 8 && $number =~ /^0([0-9]+)$/) {
            #
            # Test both upper and lower case
            #
            foreach my $key ($base, "$base^") {
                my $number = $key =~ /\^$/ ? uc $number : $number;
                my $signed = $key =~ /\^$/ ? uc $signed : $signed;
                $test {$key} -> match ($number, 
                                        test     =>  "Plain number",
                                        captures =>  [[number     => $number],
                                                      [sign       => ''],
                                                      [prefix     => ''],
                                                      [abs_number => $number]]
                );

                $test {$key} -> match ($signed, 
                                        test     =>  "Signed number",
                                        captures =>  [[number     => $signed],
                                                      [sign       => $sign],
                                                      [prefix     => ''],
                                                      [abs_number => $number]]
                );
            }
        }

        foreach my $key ($base, "$base^") {
            my $number        = $key =~ /\^$/ ? uc $number   : $number;
            my $prefixed      = $key =~ /\^$/ ? uc $prefixed : $prefixed;
            my $prefix_signed = $key =~ /\^$/ ? uc $prefix_signed
                                              :    $prefix_signed;
            my $prefix        = $key =~ /\^$/ ? uc $prefix   : $prefix;


            #
            # Test with prefix
            #
            $test {$key} -> match ($prefixed, 
                                    test     =>  "Prefixed number",
                                    captures =>  [[number     => $prefixed],
                                                  [sign       => ''],
                                                  [prefix     => $prefix],
                                                  [abs_number => $number]]
            );

            #
            # ... and a sign
            #
            $test {$key} -> match ($prefix_signed, 
                                    test     =>  "Signed prefixed number",
                                    captures => [[number     => $prefix_signed],
                                                 [sign       => $sign],
                                                 [prefix     => $prefix],
                                                 [abs_number => $number]]
            );
        }
    }
}

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
