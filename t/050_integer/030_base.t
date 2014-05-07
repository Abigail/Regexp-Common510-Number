#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp 2013041801;

our $r = eval "require Test::NoWarnings; 1";

my %test;

my $chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

my $PLAIN = 0;
my $LOWER = 1;
my $MIXED = 2;
my $UPPER = 3;

foreach my $base (2 .. 36) {
    $test {$base} [$PLAIN] = Test::Regexp:: -> new -> init (
        pattern            =>  RE (Number => 'integer', -base => $base),
        keep_pattern       =>  RE (Number => 'integer', -base => $base,
                                                        -Keep => 1),
        full_text          =>  1,
        name               => "Number integer: -base => $base",
    );

    $test {$base} [$LOWER] = Test::Regexp:: -> new -> init (
        pattern            =>  RE (Number => 'integer', -base => $base,
                                                        -case => "lower"),
        keep_pattern       =>  RE (Number => 'integer', -base => $base,
                                                        -Keep => 1,
                                                        -case => "lower"),
        full_text          =>  1,
        name               => "Number integer: -base => $base, -case => lower",
    );

    $test {$base} [$MIXED] = Test::Regexp:: -> new -> init (
        pattern            =>  RE (Number => 'integer', -base => $base,
                                                        -case => "mixed"),
        keep_pattern       =>  RE (Number => 'integer', -base => $base,
                                                        -Keep => 1,
                                                        -case => "mixed"),
        full_text          =>  1,
        name               => "Number integer: -base => $base, -case => mixed",
    );

    $test {$base} [$UPPER] = Test::Regexp:: -> new -> init (
        pattern            =>  RE (Number => 'integer', -base => $base,
                                                        -case => "upper"),
        keep_pattern       =>  RE (Number => 'integer', -base => $base,
                                                        -Keep => 1,
                                                        -case => "upper"),
        full_text          =>  1,
        name               => "Number integer: -base => $base, -case => upper",
    );
}

#
# Test characters matched
#
my $c = 0;
foreach my $base (2 .. 36) {
    $c ++;
    my $number    = substr $chars => 0, $base;
    my $sign      = $c & 1 ? "-" : "+";
    my $signed    = "$sign$number";
    my $lc_number = lc $number;
    foreach my $key ($PLAIN, $MIXED, $UPPER) {
        $test {$base} [$key] -> match ($number,
                                        test     => "Basic number",
                                        captures => [[number     => $number],
                                                     [sign       => ''],
                                                     [abs_number => $number]]
        );

        $test {$base} [$PLAIN] -> match ("$sign$number",
                                          test     => "Basic signed number",
                                          captures => [[number     => $signed],
                                                       [sign       => $sign],
                                                       [abs_number => $number]]
        );
    }

    foreach my $key ($MIXED, $LOWER) {
        $test {$base} [$key] -> match ($lc_number,
                                        test     => "Basic number, lower case",
                                        captures => [[number     => $lc_number],
                                                     [sign       => ''],
                                                     [abs_number => $lc_number]]
        );
    }

    #
    # Make sure '0' and a long string of '0's are matched.
    #
    my $zero  =  0;
    my $zeros = "0" x 100;
    foreach my $key ($PLAIN, $LOWER, $MIXED, $UPPER) {
        $test {$base} [$key] -> match ($zero,
                                        test     => "Zero",
                                        captures => [[number     => $zero],
                                                     [sign       => ''],
                                                     [abs_number => $zero]]
        );

        $test {$base} [$key] -> match ("+$zero",
                                        test     => "Positive zero",
                                        captures => [[number     => "+$zero"],
                                                     [sign       => '+'],
                                                     [abs_number => $zero]]
        );

        $test {$base} [$key] -> match ("-$zero",
                                        test     => "Negative zero",
                                        captures => [[number     => "-$zero"],
                                                     [sign       => '-'],
                                                     [abs_number => $zero]]
        );

        $test {$base} [$key] -> match ($zeros,
                                        test     => "Many zeros",
                                        captures => [[number     => $zeros],
                                                     [sign       => ''],
                                                     [abs_number => $zeros]]
        );
    }
}



Test::NoWarnings::had_no_warnings () if $r;

done_testing;
