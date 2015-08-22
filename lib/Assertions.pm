#!/usr/bin/env perl

package Assertions;

use strict;
use Carp;
use Caller qw/static/;
require Exporter;

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/
	must should true false
/;

sub TRUE_ERROR { "Expression must evaluate to true but was otherwise"; }
sub FALSE_ERROR { "Expression must evaluate to false but was otherwise."; }
sub SHOULD_ERROR { "Expression should evaluate to true but was otherwise."; }
sub DEF_ERROR { "A value must be defined."; }

#
#
#
#
sub must {
	_express( static(@_), sub {
		Capr::croak( $_ );
	}, $_[$#_]);
}

sub should {
	_express( static(@_), sub { 
		Carp::carp( $_ // SHOULD_ERROR );
		0;
	}, $_[$#_]);
}

sub true {
	must @_;
}

sub false {
	my @a = static @_;
	$a[0] = !$a[0];
	$a[1] //= FALSE_ERROR;
	must @a;
}

sub _express {
	scalar( $_[0] ) ? 1 : $_[1]->( $_[2] );
}

1;