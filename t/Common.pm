package t::Common;

use 5.010;

use Test::Regexp;
use Regexp::Common510 qw [!pattern +RE];
use Exporter ();

use strict;
use warnings;
no  warnings 'syntax';


our @ISA    = qw [Exporter];
our @EXPORT = qw [integer_tester decimal_tester];


sub integer_tester {
    my %args = @_;

    my $args = delete $args {-args} || [];
    my $name = delete $args {-name};

    Test::Regexp:: -> new -> init (
        pattern      => RE (Number => 'integer', @$args),
        keep_pattern => RE (Number => 'integer', @$args, -Keep => 1),
        full_text    => 1,
        name         => $name ? "Number integer: $name" : "Number integer",
        %args
    )
}


sub decimal_tester {
    my %args = @_;

    my $args = delete $args {-args} || [];
    my $name = delete $args {-name};

    Test::Regexp:: -> new -> init (
        pattern      => RE (Number => 'decimal', @$args),
        keep_pattern => RE (Number => 'decimal', @$args, -Keep => 1),
        full_text    => 1,
        name         => $name ? "Number decimal: $name" : "Number decimal",
        %args
    )
}


1;


__END__
