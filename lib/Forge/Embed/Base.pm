#!/usr/bin/env perl
package Forge::Embed::Base;

# Base from mojolicious plugin base
#use Mojo::Base 'Mojolicious::Plugin';

use strict;
use warnings;
use utf8;

use Log::Any qw[$log];
use Log::Any::Adapter ('Stdout');

use Data::Dumper;

sub DESTROY {}

sub import {
	my $class = shift;
	print Dumper($class) . "\n";

	#require "Mojo::Base";
	#require "Mojolicious::Plugin";

	my $caller = caller;
	no strict 'refs';
	push @{ "${caller}::ISA" }, ( "Mojo::Base", "Mojolicious::Plugin" );
	*{ "${caller}::register" } = \&_register;

	$_->import for qw[strict warnings utf8];
}

#
# Register subroutins as application-wide helpers/tag-libraries
#
sub _register {
	my ($self, $app) = @_;
	my $ref;
	my @subs = (); # Declared subroutines as helpers.

	($self, $app) = @_;
	$ref = ref($self);

	# Нужно погрепать все sub-хелперы, посему no strict refs
	REFS: {
		no strict 'refs';
		@subs = grep { defined &{"$ref\::$_"} } keys %{"$ref\::"};

		for my $sub (@subs) {
			# We do not want `privated` methods here and also register sub itself
			next if ($sub eq 'register' || $sub eq 'Dumper' || $sub eq 'import' || index($sub, '_') == 0);
			
			$app->helper("$sub" => \&{ $sub });
			$log->debug( "HELPER: Registered helper method [$ref\::$sub\()]" );
		}
	}
}

1;