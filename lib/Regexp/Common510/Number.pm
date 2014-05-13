package Regexp::Common510::Number;

use 5.010;
use strict;

use Regexp::Common510 qw [+pattern +unique_name];

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
        -pattern => \&constructor,
;


pattern Number   => 'decimal',
        -config  => {
            -sign      => '[-+]?',
            -base      =>   undef,
            -chars     =>   undef,
            -case      =>   undef,
            -sep       =>   undef,
            -group     =>   undef,
            -places1   =>   undef,
            -places2   =>   undef,
            -unsigned  =>   undef,
            -prefix    =>   undef,
            -radix     =>  '[.]',
            -precision =>   undef,
        },
        -pattern => \&constructor,
;


sub _croak {
    require Carp;
    Carp::croak (@_);
}


sub constructor {
    my %args      = @_;
    my $warn      = $args {-Warn};

    my $sign      = $args {-sign};
    my $base      = $args {-base};
    my $case      = $args {-case} // "";
    my $sep       = $args {-sep};
    my $group     = $args {-group};
    my $places    = $args {-places};     # Integer only
    my $unsigned  = $args {-unsigned};
    my $prefix    = $args {-prefix};
    my $chars     = $args {-chars};
    my $radix     = $args {-radix};      # Decimal only
    my $precision = $args {-precision};  # Decimal only

    my $Type      = $args {-Name} [0];   # integer, decimal, real

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

        if (lc $case eq 'lower') {
            $class = lc $class;
        }
        elsif (lc $case eq 'upper') {
            $class = uc $class;
        }
        else {
            #
            # Remove duplicates
            #
            my %seen;
            $class = join "" => grep  {!$seen {$_} ++}
                                map   {lc, uc}
                                split // => $class;
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
        my $uname   = unique_name;
        $abs_number = "[$class]$pre_quant" .
                      "(?:(?<$uname>(?k<sep>:$sep))[$class]$group_quant" .
                                    "(?:\\g{$uname}[$class]$group_quant)*)?";
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

    if ($Type eq 'integer') {
        return "(?k<number>:$sign_pat$prefix_pat(?k<abs_number>:$abs_number))";
    }
    elsif ($Type eq 'decimal') {
        my $radix              = defined $radix ? "(?k<radix>:$radix)" : "";
        my $integer            = "(?k<integer>:[$class]+)";
        my $integer_empty      = "(?k<integer>:)";
        my $fraction           = "(?k<fraction>:[$class]*)";
        my $fraction_non_empty = "(?k<fraction>:[$class]+)";
        return "(?k<number>:$sign_pat$prefix_pat"    .  # Sign, prefix
               "(?k<abs_number>:(?|"                 .  # Two cases
                    "$integer(?:${radix}$fraction)?" .  # With integer part
                    "|"                              .  # or
                    "$integer_empty${radix}$fraction_non_empty)))"; # without
    }
    elsif ($Type eq 'real') {
        return "";
    }
    else {
        _croak "Impossible type '$Type'";
    }
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


=head2 Named Captures

If C<< -Keep => 1 >> is used, the resulting patterns will contain 
capturing parenthesis, using named captures. (For details on C<< -Keep >>,
see the L<< Regexp::Common510 >> manual page). Below are the possible
captures for I<< Integers >>, I<< Decimals >>, and I<< Reals >>. Some
captures will be present by default, others only when using a particular
option.

=over 2

=item C<< $+ {abs_number} >>

Captures the number, without the sign or prefix. This capture will
always be present.

=item C<< $+ {fraction} >>

This capture is always present for decimal and real numbers, and never
for integer numbers. Captures the part after the radix point. If no
radix point is present, this capture will be undefined. If a radix
point is present, but no digits follow the radix point, the capture
will be the empty string.

=item C<< $+ {integer} >>

This capture is always present for decimal and real numbers, and never
for integer numbers. Captures the part before the radix point (or the whole
number if no radix point is present). The sign nor the prefix are 
part of this capture.

=item C<< $+ {number} >>

Captures the entire number. This capture will always be present.

=item C<< $+ {prefix} >>

Captures the prefix (see below). This capture is only present if the
C<< -prefix >> option is used (or C<< -base >> with a named option).

=item C<< $+ {radix} >>

This capture is always present for decimal numbers and real numbers,
and never for patterns matching integers. It captures the radix point
(decimal point). If no radix point is present, the capture will be
undefined.

=item C<< $+ {sep} >>

This capture is only present if the C<< -sep >> option is used, in
which case it matches the used separator. If no separator is present,
C<< $+ {sep} >> will be undefined.

=item C<< $+ {sign} >>

Captures the sign, if present. When matching against an unsigned 
integer, C<< $+ {sign} >> will be an empty string. The capture will
always be present, unless C<< -sign => undef >> or C<< -unsigned => 1 >>
is given as an option.

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

The C<< -prefix >> option is used to define a prefix -- a pattern that
appears between the sign and the number itself. One of its main uses is
to be able to match binary, octal, or hexadecimal numbers with a 
C<< '0b' >>, C<< '0' >>, or C<< '0x' >> prefix. 

If a C<< -prefix >> option is used, in combination with C<< -Keep => 1 >>,
a named capture C<< prefix >> will be set, so that C<< $+ {prefix} >> is
the matched prefix. 

Be careful, the value following C<< -prefix >> will be directly
interpolated into returned pattern; it's the responsibility of the caller
to make sure it's valid syntax.

=item C<< -sep => PATTERN >>

To match integers using a separator (for instance, a thousands separator
using a comma, or Perl's underscore), use the C<< -sep >> option. Its
value is a pattern matching the separator.

It is possible to use a pattern that allows for different separators,
however, the pattern requires that all separators in the number
must be equal. (So, if C<< -sep => '[,.]' >> is used, which allows
for commas and dots as separator, that the pattern matches numbers
that have either commas, or dots as separator, but not a mixtures
of commas and dots). In order to enforce this, any use of C<< -sep >>
(regardless whether C<< -Keep => 1 >> is used), will set a named
captures (a generated name).

If the C<< -sep >> option is used in combination with C<< -Keep => 1 >>,
a named capture C<< sep >> will be set, so that C<< $+ {sep} >> is the
matched separator.

Be careful, the value following C<< -sep >> will be directly
interpolated into returned pattern; it's the responsibility of the caller
to make sure it's valid syntax.

Use of the C<< -sep >> option means any C<< -places >> option is ignored.

=item C<< -sign => PATTERN >>

The C<< -sign >> option denotes the subpattern that matches the sign of
the matched number. It defaults to C<< '[-+]?' >>, that is an optional
plus or minus. If C<< -sign => undef >> is given, the pattern will only
match unsigned integer, and C<< $+ {sign} >> will not be defined.

Be careful, the value following C<< -sign >> will be directly interpolated
into returned pattern; it's the responsibility of the caller to make sure
it's valid syntax.

=item C<< -unsigned => 1 >>

This is a short-cut for C<< -sign => undef >>; that is, the resulting
patterns will match unsigned integers, and there will be no C<< sign >>
named captures.


=back


=head1 EXAMPLES

 "123"        =~ RE (Number => 'integer');
 "+123"       =~ RE (Number => 'integer');
 "- 123"      =~ RE (Number => 'integer', -sign => '[-+] ');
 "+123"       !~ RE (Number => 'integer', -unsigned => 1);
 "123AB"      =~ RE (Number => 'integer', -base => 14);
 "123ab"      =~ RE (Number => 'integer', -base => 14, -case => "lower");
 "0xbeefface" =~ RE (Number => 'integer', -base => 'hex');
 "+ABCDEF"    =~ RE (Number => 'integer', -chars => "ABCDEFGHIJKLMN");
 "12345"      =~ RE (Number => 'integer', -places => 5);
 "1234"       !~ RE (Number => 'integer', -places => 5);
 "1234"       =~ RE (Number => 'integer', -places => "3,5");
 "0b001101"   =~ RE (Number => 'integer', -base => 2, -prefix => '0b');
 "1_234_456"  =~ RE (Number => 'integer', -sep => '_');
 "1_234_456"  !~ RE (Number => 'integer', -sep => '_', -group => 4);
 "1_234_456"  =~ RE (Number => 'integer', -sep => '_', -group => "2,4");

B<< Note: >> The C<< !~ >> is some of the examples above is a white lie.
Some of the examples will match, but the match won't start at the beginning
of the string -- for instance, C<< "+123" >> will match against
C<< RE (Number => 'integer', -unsigned => 1); >>, but that's only because
C<< "123" >> does.

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
