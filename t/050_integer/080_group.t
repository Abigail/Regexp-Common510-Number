#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my $test = integer_tester -args => [-sep => ",", -group => 3],
                          -name => "Groups of three";

my @data = (
    ["plain number"    => "0", "12", "000"],
    ["two groups"      => "1,234", "123,456"],
    ["multiple groups" => "1,234,567", "12,345,678,901,234"],
);

foreach my $entry (@data) {
    my ($test_name, @numbers) = @$entry;

    my $sep = $test_name =~ /^plain/ ? undef : ",";

    foreach my $number (@numbers) {
        $test -> match ($number,
                         test     => "\u$test_name",
                         captures => [[number     => $number],
                                      [sign       => ""],
                                      [abs_number => $number],
                                      [sep        => $sep]],
        );

        my $signed = "-$number";

        $test -> match ($signed,
                         test     => "Signed; $test_name",
                         captures => [[number     => $signed],
                                      [sign       => "-"],
                                      [abs_number => $number],
                                      [sep        => $sep]],
        );
    }
}



$test = integer_tester -args => [-sep => ",", -group => "2,5"],
                       -name => "Groups two to five";


@data = (
    ["plain number"    => "0", "12", "000", "12345"],
    ["two groups"      => "1,23", "12,34567", "1234,56"],
    ["multiple groups" => "12,345,7890,12345,67"],
);


foreach my $entry (@data) {
    my ($test_name, @numbers) = @$entry;

    my $sep = $test_name =~ /^plain/ ? undef : ",";

    foreach my $number (@numbers) {
        $test -> match ($number,
                         test     => "\u$test_name",
                         captures => [[number     => $number],
                                      [sign       => ""],
                                      [abs_number => $number],
                                      [sep        => $sep]],
        );

        my $signed = "-$number";

        $test -> match ($signed,
                         test     => "Signed; $test_name",
                         captures => [[number     => $signed],
                                      [sign       => "-"],
                                      [abs_number => $number],
                                      [sep        => $sep]],
        );
    }
}


is RE (Number => 'integer', -group => 3),
   RE (Number => 'integer', -group => 3, -sep => ","),
   "Pattern defaults to -sep => ','";


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
