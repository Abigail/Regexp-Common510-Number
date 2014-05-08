#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my $test_comma   = integer_tester -args => [-sep => ","],
                                  -name => "Comma separator";

my $test_dot     = integer_tester -args => [-sep => "."],
                                  -name => "Dot separator";

my $test_complex = integer_tester -args => [-sep => "[.,]"],
                                  -name => "Complex separator";

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
        my $dotted = $number; $dotted =~ s/,/./g;
        my $signed = "+$number";

        $test_comma   -> match ($number,
                                 test     => "\u$name",
                                 captures => [[number     => $number],
                                              [sign       => ""],
                                              [abs_number => $number],
                                              [sep        => $csep]]);

        $test_comma   -> match ($signed,
                                 test     => "Signed, $name",
                                 captures => [[number     => $signed],
                                              [sign       => "+"],
                                              [abs_number => $number],
                                              [sep        => $csep]]);

        $test_dot     -> match ($dotted,
                                 test     => "\u$name",
                                 captures => [[number     => $dotted],
                                              [sign       => ""],
                                              [abs_number => $dotted],
                                              [sep        => $dsep]]);

        $test_complex -> match ($number,
                                 test     => "\u$name",
                                 captures => [[number     => $number],
                                              [sign       => ""],
                                              [abs_number => $number],
                                              [sep        => $csep]]);

    }
}

my $number1 = "1,2.3,4.5789";
my $number2 = "1.2,3.4,5789";
$test_complex -> match ($number1,
                         test     => "Mixed separators",
                         captures => [[number     => $number1],
                                      [sign       => ""],
                                      [abs_number => $number1],
                                      [sep        => '.']]);
                          
$test_complex -> match ($number2,
                         test     => "Mixed separators",
                         captures => [[number     => $number2],
                                      [sign       => ""],
                                      [abs_number => $number2],
                                      [sep        => ',']]);
                          




Test::NoWarnings::had_no_warnings () if $r;

done_testing;
