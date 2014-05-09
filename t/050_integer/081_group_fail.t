#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use t::Common;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my $test = integer_tester -args => [-sep => ",", -group => "3"],
                          -name => "Groups of three";

my @tests = (
    ["Empty string"                    => ""],
    ["Too many digits without a group" => "1234"],
    ["Leading separator"               => ",123"],
    ["Too many digits in group"        => "1234,567", "12,345,5678,901",
                                          "1,234,567,890,1234"],
    ["Not enough digits in group"      => "12,345,67,890"],
);

foreach my $entry (@tests) {
    my ($reason, @numbers) = @$entry;
    foreach my $number (@numbers) {
        $test -> no_match ($number, reason => $reason);
    }
}



$test = integer_tester -args => [-sep => ",", -group => "2,4"],
                       -name => "Groups of two to four";

@tests = (
    ["Empty string"                    => ""],
    ["Too many digits without a group" => "12345"],
    ["Leading separator"               => ",123"],
    ["Too many digits in group"        => "12345,678", "12,345,56789,01",
                                          "1,234,567,890,12345"],
    ["Not enough digits in group"      => "12,345,6,7890"],
);

foreach my $entry (@tests) {
    my ($reason, @numbers) = @$entry;
    foreach my $number (@numbers) {
        $test -> no_match ($number, reason => $reason);
    }
}




Test::NoWarnings::had_no_warnings () if $r;

done_testing;
