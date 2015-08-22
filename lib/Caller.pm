#!/usr/bin/env perl

package Caller;

require Exporter;

our @ISA = qw/Exporter/;
our @EXPORT = qw/static/;

#
# Returns array of arguments of caller without package reference
# Meaning that sub may be called as static without referencing.
# E.g.
# 	Foo::bar
# 	Foo->bar
# 	$foo->bar
#
sub static {
	shift if $_[0] eq caller;
	@_;
}