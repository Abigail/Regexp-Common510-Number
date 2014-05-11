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
            -base     =>   undef,
            -chars    =>   undef,
            -case     =>   undef,
            -sep      =>   undef,
            -group    =>   undef,
            -places   =>   undef,
            -unsigned =>   undef,
            -prefix   =>   undef,
        },
        -pattern => \&integer_constructor,
;


sub _croak {
    require Carp;
    Carp::croak (@_);
}


sub integer_constructor {
    my %args     = @_;
    my $warn     = $args {-Warn};

    my $sign     = $args {-sign};
    my $base     = $args {-base};
    my $case     = $args {-case} // "";
    my $sep      = $args {-sep};
    my $group    = $args {-group};
    my $places   = $args {-places};
    my $unsigned = $args {-unsigned};
    my $prefix   = $args {-prefix};
    my $chars    = $args {-chars};

    #
    # Set defaults for -chars and -base. We cannot use fixed defaults.
    #
    if (!defined $chars || $chars eq "") {
        $chars  = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        $base //= 10;
    }
    else {
        $base //= length $chars;
    }

    my $max_base = length $chars;


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
    elsif ($base =~ /[^0-9]/ || $base < 1 || $base > $max_base) {
        _croak "-base must be an unsigned integer between " .
               "1 and $max_base inclusive";
    }

    my $class = quotemeta substr $chars => 0, $base;

    if ($case) {
        if (lc $case !~ /^(?:upper|lower|mixed)$/) {
            _croak "-case should be one of 'upper', 'lower' or 'mixed'";
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

    #
    # Create the pattern for 'abs_number'. This depends on -places, 
    # -sep, and -group.
    #
    my $abs_number = "";
    if (defined $sep || defined $group) {
        if (defined $places) {
            if ($warn) {
                warn "You cannot have -places if you also have -sep, " .
                     "or a -group; ignoring the -places parameter";
            }
            undef $places;
        }
        $sep //= ',';       # Default.
        if ($sep eq '.') {  # Special case.
            $sep = '[.]';
        }
        my $pre_quant   = "+";
        my $group_quant = "+";
        if (defined $group) {
            if ($group =~ /^[0-9]+$/) {
                $pre_quant   = "{1,$group}";
                $group_quant = "{$group}";
            }
            elsif ($group =~ /^([0-9]+),([0-9]+)$/) {
                my ($f, $s) = ($1, $2);
                if ($f > $s) {
                    _croak "Can't do -group => n,m with n > m";
                }
                $pre_quant   = "{1,$s}";
                $group_quant = "{$f,$s}";
            }
            else {
                _croak "Don't know what to do with '-group => $group'";
            }
        }
        $abs_number = "[$class]$pre_quant" .
                      "(?:(?k<sep>:$sep)[$class]$group_quant)*";
    }
    elsif (defined $group) {
        if ($warn) {
            warn "You must define a separator (-sep) if you have -group " .
                 "size; ignoring the -group parameter\n"
        }
        undef $group;
    }
    elsif (defined $places) {
        my $quant;
        if ($places =~ /^[0-9]+$/) {
            $quant = "{$places}";
        }
        elsif ($places =~ /^([0-9]+),([0-9]+)$/) {
            my ($f, $s) = ($1, $2);
            if ($f > $s) {
                _croak "Can't do -places => n,m with n > m";
            }
            $quant = "{$f,$s}";
        }
        else {
            _croak "Don't know what to do with '-places => $places'";
        }
        $abs_number = "[$class]$quant";
    }
    else {
        $abs_number = "[$class]+";
    }

    my $sign_pat   = defined $sign && !$unsigned ? "(?k<sign>:$sign)"     : "";
    my $prefix_pat = defined $prefix             ? "(?k<prefix>:$prefix)" : "";

    return "(?k<number>:$sign_pat$prefix_pat(?k<abs_number>:$abs_number))";
}


1;

__END__

=head1 NAME

Regexp::Common510::Number - Abstract

=head1 SYNOPSIS

 use Regexp::Common510 'Number';

 "-12345" =~ RE Number => 'integer';

=head1 DESCRIPTION

This module provides patterns for various numbers. The general syntax to
get a pattern is:

 use Regexp::Common510 'Number';
 my $pattern = RE (Number => <TYPE>, options...);

That is, the C<< RE >> subroutine is exported by using C<< Regexp::Common510 >>.
To get any number related pattern, the first argument of the C<< RE >> 
subroutine should be the string C<< Number >>, followed by a string
indicating which kind of number the pattern should be for. After the
two strings follows zero or more options (as key value pairs). The types
and their options are discussed below:

=head2 Integer Numbers

 my $pattern = RE (Number => 'integer');
 my $pattern = RE (Number => 'integer', options...);
 my $pattern = RE (Number => 'integer', -Keep => 1, options...);

If the first two arguments of the C<< RE >>, subroutine are C<< Number >>,
and C<< integer >>, a pattern recognizing integers is returned. Without
options, this means the pattern recognizes a non-empty string consisting
(ASCII) digits, optionally prefixed with a plus or a minus sign.

If the C<< -Keep >> option is given the returned pattern will contain
capturing parenthesis, using named captures. (For details on C<< -Keep >>,
see the L<< Regexp::Common510 >> manual page). By default, the captures
below will be present, but the set can change given the pattern modifying
options, as described in the next subsection.

=over 2

=item C<< $+ {number} >>

Captures the entire number.

=item C<< $+ {sign} >>

Captures the sign, if present. When matching against an unsigned 
integer, C<< $+ {sign} >> will be an empty string.

=item C<< $+ {abs_number} >>

Captures the number, without the sign.

=back

=head3 Pattern modifying options

The following pattern modifying options are recognized (all options 
consist of a name and a value):

=over 2

=item C<< -base => NUMBER >>

This option indicates the base of integer being matched. The default is 10.
Bases lower than 10 match subsets of numbers -- if the base exceeds letters
will be matched, starting with C<< 0 .. 9, 'A' >> for base 11, all the way to 
C<< 0 .. 9, 'A' .. 'Z' >> for base 36. 

The smallest allowed base is 1 (which results in a pattern that matches
a string of C<< '0' >>s), and the maximum base is 36 (but see the exception
mentioned under the discussion of the C<< -chars >> option).

Bases exceeding 10 results in patterns matching integer using B<< uppercase >>
letters. This can be changed using the C<< -case >> option.

=item C<< -base => 'bin'|'BIN'|'BiN'|'oct'|'hex'|'HEX'|'HeX' >>

Using C<< -base >> with a value of C<< bin >>, C<< oct >> or C<< hex >>
in some casing is a short cut for setting as given in the table below:

 +--------------+-----------------------------------------------------+
 |   Option     |                Expands to                           |
 +--------------+-----------------------------------------------------+
 |-base => 'bin'|-base =>  2, -prefix => '(?:0b)?'                    |
 |-base => 'BIN'|-base =>  2, -prefix => '(?:0B)?'                    |
 |-base => 'BiN'|-base =>  2, -prefix => '(?:0[bB])?'                 |
 |-base => 'oct'|-base =>  8, -prefix => '(?:0)?'                     |
 |-base => 'hex'|-base => 16, -prefix => '(?:0x)?',   -case => 'lower'|
 |-base => 'HEX'|-base => 16, -prefix => '(?:0X)?',   -case => 'upper'|
 |-base => 'HeX'|-base => 16, -prefix => '(?:0[xX])?' -case => 'mixed'|
 +--------------+-----------------------------------------------------+

That is, it results in patterns matching binary, octal or hexadecimal
numbers, with optional, standard, prefixes (C<< 0b >>, C<< 0 >>, and
C<< 0x >>). If the name is in all lowercase, the prefix, if given,
must be in lowercase. If the name is in all uppercase, the prefix must
be so as well. If the name is mixed case, the prefix may be either.
(For C<< oct >>, this all results in the same prefix). For the C<< hex >>
bases, the casing also indicates the casing of the hex digits.

See also the descriptions of the C<< -prefix >> and C<< -case >> options.

=item C<< -case => 'lower' | 'upper' | 'mixed' >>

By default, if a base greater than 10 is used, the patterns match against
upper case characters. This can be changed using the C<< -case >>
parameter. It takes one of three values: C<< 'lower' >>, C<< 'upper' >>, 
or C<< 'mixed' >>, indicating whether the pattern should match agains
lower case characters, upper case characters or either case.

=item C<< -chars => "CHARACTERLIST" >>

By default, the patterns returned match number using ASCII digits, 
and, if the base exceeds 10, ASCII upper case characters.

This set of characters can be changed using the C<< -chars >> option;
as argument it takes a string, and the pattern matches characters from
this string. If C<< -base => BASE >> is given as an option as well,
the first C<< BASE >> characters of the character list are used; it's
an error to use a C<< BASE >> exceeding the length of the character list.

This option can be used to match integers using digits from different
Unicode scripts.

=item C<< -group => NUMBER | "NUMBER,NUMBER" >>

If you are using the C<< -sep >> option (see below), allowing your
integers to have separators, you can control the size of the groups
using the C<< -group >> option. If its value consists of a single,
positive integer, all groups (except the first), must be of the given
length. The leading group may be shorter, but not longer. If the value
of the C<< -group >> option consists of two numbers separated by a 
comma, the length of each group must be between the two numbers (inclusive);
the length of leading group may not exceed the maximum (but may be smaller
than the minimum length of the other groups).

If C<< -group >> is used without a C<< -sep >>, a separator consisting of
a comma C<< ',' >> is implied.

A C<< -places >> option is ignored (with a warning) if a C<< -group >>
option is used.

=item C<< -places => NUMBER | "NUMBER,NUMBER" >>

The C<< -places >> option determines the length (excluding a sign or
a prefix, see the discussions of C<< -sign >> and C<< -prefix >> below)
of the matched number. If the C<< -places >> option has a value consisting
of a single non-negative digit, the matched integer must be exactly this
length. If the C<< -places >> option consists of two numbers, separated
by a comma, the number of be of a length not smaller than the first number,
and not exceeding the second number.

The C<< -places >> option is ignored if a C<< -group >> or a C<< -sep >>
option is used.

=item C<< -prefix => PATTERN >>

TODO

=item C<< -sep => PATTERN >>

TODO

=item C<< -sign => PATTERN >>

The C<< -sign >> option denotes the subpattern that matches the sign of
the matched number. It defaults to C<< '[-+]?' >>, that is an optional
plus or minus. If C<< -sign => undef >> is given, the pattern will only
match unsigned integer, and C<< $+ {sign} >> will not be defined.

Be careful, the value following C<< -sign >> will be directly interpolated
into returned pattern; it's the responsibility of the caller to make sure
it's valid syntax.

=item C<< -unsigned => 1 >>

TODO


=back


=head1 EXAMPLES

 "123"   =~ RE (Number => 'integer');
 "- 123" =~ RE (Number => 'integer', -sign => '[-+] ');


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
