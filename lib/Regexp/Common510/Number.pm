package Regexp::Common510::Number;

use 5.010;
use strict;

use Regexp::Common510;

use warnings;
no  warnings 'syntax';

our $VERSION = '2013042501';


pattern Number   => 'integer',
        -config  => {
            -sign     => '[-+]?',
            -base     =>      10,
            -case     =>   undef,
            -sep      =>   undef,
            -group    =>   undef,
            -places   =>   undef,
            -unsigned =>   undef,
            -prefix   =>   undef,
        },
        -pattern => \&integer_constructor,
;


sub integer_constructor {
    my %args     = @_;
    my $warn     = $args {-Warn};

    my $sign     = $args {-sign};
    my $base     = $args {-base} // 10;
    my $case     = $args {-case} // "";
    my $sep      = $args {-sep};
    my $group    = $args {-group};
    my $places   = $args {-places};
    my $unsigned = $args {-unsigned};
    my $prefix   = $args {-prefix};

    if (defined $group && !defined $sep) {
        if ($warn) {
            warn "You must define a separator (-sep) if you have group size\n"
        }
        undef $group;
    }

    if (defined $places && defined $sep) {
        if ($warn) {
            warn "You cannot defined -places, if you have defined a " .
                 "separator (-sep)\n";
        }
        undef $places;
    }

    #
    # Process -base
    #
    $base //= 10;  # Default.
    $base   = 10 unless length $base;

    if (lc $base eq 'bin') {
        $prefix //= $base eq 'bin' ? '(?:0b)?'
                  : $base eq 'BIN' ? '(?:0B)?'
                  :                  '(?:0[bB])?';
        $base   =  2;
    }
    elsif (lc $base eq 'oct') {
        $prefix //= '(?:0)?';
        $base     =  8;
    }
    elsif (lc $base eq 'hex') {
        $prefix //= $base eq 'hex' ? '(?:0x)?'
                  : $base eq 'HEX' ? '(?:0X)?'
                  :                  '(?:0[xX])?';
        $case   = $base eq 'hex' ? 'lower'
                : $base eq 'HEX' ? 'upper'
                :                  'mixed';
        $base   = 16;
    }
    elsif ($base =~ /[^0-9]/ || $base < 1 || $base > 36) {
        require Carp;
        Carp::croak ("-base must be an unsigned integer between " .
                     "1 and 36 inclusive");
    }

    my $class = substr "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0, $base;

    if ($case) {
        if (lc $case !~ /^(?:upper|lower|mixed)$/) {
            require Carp;
            Carp::croak ("-case should be one of 'upper', 'lower' or 'mixed'");
        }

        if ($base <= 10) {
            if ($warn) {
                warn ("-case is used, but -base does not exceed 10; " .
                      "-case setting is ignored");
            }
        }
        elsif (lc $case eq 'lower') {
            $class = lc $class;
        }
        elsif (lc $case eq 'mixed') {
            $class .= lc substr $class => 10 if $base > 10;
        }
    }

    my $sign_pat   = defined $sign && !$unsigned ? "(?k<sign>:$sign)"     : "";
    my $prefix_pat = defined $prefix             ? "(?k<prefix>:$prefix)" : "";

    return "(?k<number>:$sign_pat$prefix_pat(?k<abs_number>:[$class]+))";
}


1;

__END__

=head1 NAME

Regexp::Common510::Number - Abstract

=head1 SYNOPSIS

 use Regexp::Common510 'Number';

 "-12345" =~ RE Number => 'integer';

=head1 DESCRIPTION

This module provides patterns for various numbers.

=head1 BUGS

=head1 TODO

=head1 SEE ALSO

=head1 DEVELOPMENT

The current sources of this module are found on github,
L<< git://github.com/Abigail/Regexp-Common510-Number.git >>.

=head1 AUTHOR

Abigail, L<< mailto:cpan@abigail.be >>.

=head1 COPYRIGHT and LICENSE

Copyright (C) 2013 by Abigail.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),   
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 INSTALLATION

To install this module, run, after unpacking the tar-ball, the 
following commands:

   perl Makefile.PL
   make
   make test
   make install

=cut
