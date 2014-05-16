#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use warnings 'Regexp::Common510';

our $r = eval "require Test::NoWarnings; 1";

#
# Testing named bases patterns for failures.
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

    $test {$key} = integer_tester -args => \@args,
                                  -name => $name;
}


my %wrong_base = (
    2  =>  ["2", "9", "0123", "010101019"],
    8  =>  ["8", "123484321", "0a12"],
   16  =>  ["g", "12345defg0234", "ghi"]
);

foreach my $base (2, 8, 16) {
    foreach my $number (@{$wrong_base {$base}}) {
        $test {$base} -> no_match ($number,
                                    reason  =>  "Digit(s) exceeding base");
    }
}

#
# Test whether the prefix has the right case
#
$test {  2  } -> no_match ("0B10101", reason => "Prefix has incorrect base");
$test { "2^"} -> no_match ("0b10101", reason => "Prefix has incorrect base");
$test { 16  } -> no_match ("0X12345", reason => "Prefix has incorrect base");
$test {"16^"} -> no_match ("0x12345", reason => "Prefix has incorrect base");


#
# Test 'wrong' prefixes. Do note that a '0' prefix makes for valid binary
# and hex numbers, and '0b' could be a valid start of a hex number.
#
foreach my $key (qw [2 2^ 8 8^]) {
    $test {$key} -> no_match ("0x1", reason => "Incorrect prefix");
    $test {$key} -> no_match ("0X1", reason => "Incorrect prefix");
}
foreach my $key (qw [8 8^]) {
    $test {$key} -> no_match ("0b1234", reason => "Incorrect prefix");
    $test {$key} -> no_match ("0B1234", reason => "Incorrect prefix");
}


#
# Case check for hex numbers
#
$test { 16  } -> no_match ("100A78", reason => "Incorrect casing");
$test {"16^"} -> no_match ("100a78", reason => "Incorrect casing");


#
# Empty string should not match
#
foreach my $key (qw [2 2^ 8 8^ 16 16^]) {
    $test {$key} -> no_match ("", reason => "Empty string");
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
