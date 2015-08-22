#!/usr/bin/env perl

package Web::HREF;

sub link {
	my ($self, $mojo) = (shift, shift);
	my $uri  = join '/', @_;
	my $path = $mojo->url->path;
	$mojo->url->path . $uri;
}

1;