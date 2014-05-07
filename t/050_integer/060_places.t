#!/usr/bin/perl

use 5.010;

use Test::More 0.88;
use Regexp::Common510 'Number';
use Test::Regexp 2013041801;

use strict;
use warnings;
no  warnings 'syntax';

our $r = eval "require Test::NoWarnings; 1";

my %test;

foreach my $places ("0", "3", "39", "0,2", "2,8") {
    $test {$places} = Test::Regexp:: -> new -> init (
        pattern      => RE (Number => 'integer', -places => $places),
        keep_pattern => RE (Number => 'integer', -places => $places,
                                                 -Keep   => 1),
        full_text    => 1,
        name         => "Number integer: -places => $places",
    );
}

$test {0} -> match ("",
                    test     => "Empty string",
                    captures => [[number     => ""],
                                 [sign       => ""],
                                 [abs_number => ""]],
);

#
# Yeah...
#
$test {0} -> match ("-",
                    test     => "Just a sign",
                    captures => [[number     => "-"],
                                 [sign       => "-"],
                                 [abs_number => ""]],
);


$test {3} -> match ("123",
                    test     => "Just a number",
                    captures => [[number     => "123"],
                                 [sign       => ""],
                                 [abs_number => "123"]],
);

$test {3} -> no_match ("",     reason => "Empty string");
$test {3} -> no_match ("12",   reason => "Not enough places");
$test {3} -> no_match ("1234", reason => "Too many places");
         

my $number39 = "632" x 13;
$test {39} -> match ($number39,
                     test     => "Just a number",
                     captures => [[number     => $number39],
                                  [sign       => ""],
                                  [abs_number => $number39]],
);
$test {39} -> no_match ("",       reason => "Empty string");
$test {39} -> no_match ("1" x 38, reason => "Not enough places");
$test {39} -> no_match ("1" x 40, reason => "Too many places");


foreach my $size (0 .. 2) {
    my $number = substr "123456789" => 0, $size;

    $test {"0,2"} -> match ($number,
                             test     => $size ? "Just a number"
                                               : "Empty string",
                             captures => [[number     => $number],
                                          [sign       => ""],
                                          [abs_number => $number]]);
}

$test {"0,2"} -> no_match ("123", reason => "Too many places");

foreach my $size (2 .. 8) {
    my $number = substr "123456789" => 0, $size;

    $test {"2,8"} -> match ($number,
                             test     => "Just a number",
                             captures => [[number     => $number],
                                          [sign       => ""],
                                          [abs_number => $number]]);
}

$test {"2,8"} -> no_match ("",          reason => "Empty string");
$test {"2,8"} -> no_match ("7",         reason => "Not enough places");
$test {"2,8"} -> no_match ("987654321", reason => "Too many places");
                    

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
