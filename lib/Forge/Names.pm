#!/usr/bin/env perl

package Forge::Names;

# For flexible class loading
use Class::Load;

=pod

=head2 Forge::Names->package_of( 'Foo', 'Bar', 'Baz' ) eq 'Foo::Bar::Baz';

=over 4

=item 	@data 	Data to pass to response

=back

Accepts an array of segments for package name and
tries to load package by assembled name.

Returns package name

=cut
sub package_of { # (@) -> $
	shift; # Skip this reference
	my $package_name = join '::', @_;
	# Try to load package before returning it
	TRY: {
		local $@;
		eval {
			Class::Load::load_class($package_name);
		};
		#$package = require $package_name;

		if ($@) {
			Carp::croak( "Unable to load package [$package_name]: $@" );
		}
	}

	$package_name;	
}

1;