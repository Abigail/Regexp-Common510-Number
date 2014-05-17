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
# Tests the -sign and -unsigned parameters.
#


#
# Various patterns
#
my %pattern_args = (
    "+" => ["mandatory + sign"         => -sign => '[+]'],
    "-" => ["optional - sign"          => -sign => '[-]?'],
    ""  => ["unsigned"                 => -unsigned => 1],
    "!" => ["no sign"                  => -sign => undef],
    " " => ["sign with optional space" => -sign => '(?:[-+] *)?'],
);

my %test;
foreach my $key (keys %pattern_args) {
    my ($name, @args) = @{$pattern_args {$key}};

    $test {$key} = integer_tester -args => \@args,
                                  -name => $name;
}


my @numbers = (0 .. 12, "000", 1234567890, "0987654321" x 40);


foreach my $number (@numbers) {
    my $plus   = "+$number";
    my $minus  = "-$number";
    my $minus2 = "-  $number";

    $test {"+"} -> no_match ($number,
                              reason => "No sign");

    $test {"+"} ->    match ($plus,
                              test     => "plus sign",
                              captures => [[number     =>  $plus],
                                           [sign       =>  "+"],
                                           [abs_number =>  $number]]);

    $test {"+"} -> no_match ($minus,
                              reason => "Incorrect sign");

    $test {"+"} -> no_match ($minus2,
                              reason => "Incorrect sign");

    $test {"-"} ->    match ($number,
                              test     => "no sign",
                              captures => [[number     =>  $number],
                                           [sign       =>  ""],
                                           [abs_number =>  $number]]);

    $test {"-"} -> no_match ($plus,
                              reason => "Incorrect sign");

    $test {"-"} ->    match ($minus,
                              test     => "minus sign",
                              captures => [[number     =>  $minus],
                                           [sign       =>  "-"],
                                           [abs_number =>  $number]]);

    $test {"-"} -> no_match ($minus2,
                              reason => "Space after sign not allowed");

    foreach my $key ("", "!") {
        $test {$key}  ->    match ($number,
                                    test     => "no sign",
                                    captures => [[number     =>  $number],
                                                 [abs_number =>  $number]]);

        $test {$key}  -> no_match ($plus,
                                    reason => "Sign not allowed");

        $test {$key}  -> no_match ($minus,
                                    reason => "Sign not allowed");

        $test {$key}  -> no_match ($minus2,
                                    reason => "Sign not allowed");
    }

    $test {" "} ->    match ($number,
                              test     => "no sign",
                              captures => [[number     =>  $number],
                                           [sign       =>  ""],
                                           [abs_number =>  $number]]);

    $test {" "} ->    match ($plus,
                              test     => "plus sign",
                              captures => [[number     =>  $plus],
                                           [sign       =>  "+"],
                                           [abs_number =>  $number]]);

    $test {" "} ->    match ($minus,
                              test     => "minus sign",
                              captures => [[number     =>  $minus],
                                           [sign       =>  "-"],
                                           [abs_number =>  $number]]);

    $test {" "} ->    match ($minus2,
                              test     => "sign with space",
                              captures => [[number     =>  $minus2],
                                           [sign       =>  "-  "],
                                           [abs_number =>  $number]]);
}


foreach my $garbage ("", "+", "-", " ") {
    foreach my $test (values %test) {
        $test -> no_match ($garbage, reason => "Not a number")
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
