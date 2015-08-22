#!/usr/bin/env perl

use Data::Dumper;

use feature qw/say/;

require Exporter;

our @EXPORT = qw[dump];

sub dump { # (@) -> X !
	map(_dump, @_);
}

sub _dump {
	say Dumper($_);
}