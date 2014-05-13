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
);

my %test;
foreach my $key (keys %pattern_args) {
    my ($name, @args) = @{$pattern_args {$key}};

    $test {$key} = decimal_tester -args => \@args,
                                  -name => $name;
}


my @numbers = ("0", "00.00", "12345.6789", "1.", ".2");


foreach my $number (@numbers) {
    my $plus   = "+$number";
    my $minus  = "-$number";

    my $integer;
    my $fraction;
    my $radix;

    if ($number =~ /[.]/p) {
        $integer  = ${^PREMATCH};
        $fraction = ${^POSTMATCH};
        $radix    = ".";
    }
    else {
        $integer  = $number;
    }

    my @matches = (
        [abs_number => $number],
        [integer    => $integer],
        [radix      => $radix],
        [fraction   => $fraction],
    );

    $test {"+"} -> no_match ($number,
                              reason => "No sign");

    $test {"+"} ->    match ($plus,
                              test     => "plus sign",
                              captures => [[number     =>  $plus],
                                           [sign       =>  "+"],
                                           @matches,
                                          ]);

    $test {"+"} -> no_match ($minus,
                              reason => "Incorrect sign");

    $test {"-"} ->    match ($number,
                              test     => "no sign",
                              captures => [[number     =>  $number],
                                           [sign       =>  ""],
                                           @matches,
                                          ]);

    $test {"-"} -> no_match ($plus,
                              reason => "Incorrect sign");

    $test {"-"} ->    match ($minus,
                              test     => "minus sign",
                              captures => [[number     =>  $minus],
                                           [sign       =>  "-"],
                                           @matches,
                                          ]);

    foreach my $key ("", "!") {
        $test {$key}  ->    match ($number,
                                    test     => "no sign",
                                    captures => [[number     =>  $number],
                                                 @matches,
                                                ]);

        $test {$key}  -> no_match ($plus,
                                    reason => "Sign not allowed");

        $test {$key}  -> no_match ($minus,
                                    reason => "Sign not allowed");
    }
}


foreach my $garbage ("", "+", "-", " ") {
    foreach my $test (values %test) {
        $test -> no_match ($garbage, reason => "Not a number")
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
