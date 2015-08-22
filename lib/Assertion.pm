#!/usr/bin/env perl

package Assertion;

use strict;
use Carp;
use Caller qw/static/;

require Exporter;

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/
	must should true false is_scalar is_array is_hash is_code
/;

sub TRUE_ERROR { "Expression must evaluate to true but was otherwise"; }
sub FALSE_ERROR { "Expression must evaluate to false but was otherwise."; }
sub SHOULD_ERROR { "Expression should evaluate to true but was otherwise."; }
sub DEF_ERROR { "A value must be defined."; }
sub ASSERT_FAIL { "Assertion failed with message:'$_[0]' in $_[2]:$_[3]" }

#
# (Any) -> Bool
# 
# Alias for [true]
#
sub must { # $ ($, $)
	true(@_, _array_to_ref(caller));
}

#
# (Any) -> Bool
# 
# Checks expression for truth and throws warning if it evaluates to false.
# No dying here
#
sub should { # $ ($, $)
	# Get caller if exists as last argument of sub
	my $caller = is_array( $_[$#_] ) ? pop : _array_to_ref(caller);
	# Pass expression, message, false-routine and caller
	_express( $_[0], $_[1], sub {
		my @caller = @{ $_[1] };
		Carp::carp( ASSERT_FAIL($_[0], @caller) // SHOULD_ERROR );
	}, $caller);
}

#
# (Any) -> Bool
# 
# Checks expression for truth and croaks (dies) with a message if it evaluates to false
#
sub true { # $ ($, $)
	# Get caller if exists as last argument of sub
	my $caller = is_array( $_[$#_] ) ? pop : _array_to_ref(caller);
	# Pass expression, message, false-routine and caller
	_express( $_[0], $_[1], sub {
		my @caller = @{ $_[1] };
		Carp::croak( ASSERT_FAIL($_[0], @caller) // SHOULD_ERROR );
	}, $caller);
}

#
# (Any) -> Bool
# 
# Checks expression for false and croaks (dies) with a message if it evaluates to true
#
sub false { # $ ($, $)
	my @a = static @_;
	$a[0] = !_evaluate($a[0]);
	true($a[0], $a[1] // FALSE_ERROR, _array_to_ref(caller));
}

#
# (Any) -> Bool
#
# Checks if given type is scalar reference
#
sub is_scalar { # $ ($)
	_is_type(shift, 'SCALAR');
}

#
# (Any) -> Bool
#
# Checks if given type is code block reference
#
sub is_code {
	_is_type(shift, 'CODE');
}

#
# (Any) -> Bool
#
# Checks if given type is array reference
#
sub is_array {
	_is_type(shift, 'ARRAY');
}

#
# (Any) -> Bool
#
# Checks if given type is hash reference
#
sub is_hash {
	_is_type(shift, 'HASH');
}

#
# (Any) -> Bool
#
# Checks if given value is of expected type
#
sub _is_type {
	my ($ref, $type) = @_;
	defined $ref && ref($ref) eq $type;
}

#
# (Any...) -> \@
# Returns arguments of function as array reference
#
sub _array_to_ref { # \@ (@)
	\@_;
}

#
# (Any, String, Code, ArrayRef) -> Bool
# 
# Evaluates expression and calls failure function passed if it evaluates to false
#
sub _express { # $ ($, $, &, \@)
	my ($exp, $err, $code, $caller) = @_;
	_evaluate( $exp ) ? 1 : $code->( $err, $caller );
}

#
# (Any) -> Bool
#
sub _evaluate { # $ ($)
	my ($expression) = @_;
	$expression = @{ $expression } if(is_array($expression));
	$expression = %{ $expression } if is_hash($expression);
	$expression = ${ $expression } if is_scalar($expression);
	scalar $expression;
}

1;