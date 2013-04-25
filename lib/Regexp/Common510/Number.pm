package Regexp::Common510::Number;

use 5.010;
use strict;

use Regexp::Common510;

use warnings;
no  warnings 'syntax';

our $VERSION = '2013042501';

pattern Number   => 'integer',
        -config  => {
            -base     =>   10,
            -sign     => '[-+]?',
            -sep      =>  undef,
            -group    =>  undef,
            -places   =>  undef,
            -unsigned =>  undef,
        },
        -pattern => \&integer_constructor,
;


sub integer_constructor {
    my %args     = @_;
    my $warn     = $args {-Warn};

    my $base     = $args {-base};
    my $sign     = $args {-sign};
    my $sep      = $args {-sep};
    my $group    = $args {-group};
    my $places   = $args {-places};
    my $unsigned = $args {-unsigned};

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

    $base //= 10;  # Default.
    $base   = 10 unless length $base;

    if ($base =~ /[^0-9]/ || $base < 1 || $base > 36) {
        require Carp;
        Carp::croak ("-base must be an unsigned integer between " .
                     "1 and 36 inclusive");
    }

    my $class = substr "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0, $base;

    $sign = '' if $unsigned;

    return "(?k<number>:(?k<sign>:$sign)(?k<abs_number>:[$class]+))";
}


1;

__END__

=head1 NAME

Regexp::Common510::Number - Abstract

=head1 SYNOPSIS

=head1 DESCRIPTION

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
