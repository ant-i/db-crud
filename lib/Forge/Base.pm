package Forge::Base;

use strict;
use warnings;
use utf8;
use feature ();

use Carp ();
use Attribute::Handlers;
use Data::Dumper;
use Forge;

sub import {

	$_->import for qw[strict warnings utf8];

	feature->import(':5.10');
}

# sub Route : ATTR {
# 	my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;
# 	my $routes = Forge::application->routes;

# 	my @methods = ( @{ $data } [1 .. $#$data] ) // Forge::DEFAULT_ROUTE_METHODS();
	
# 	# route( uri )->via( methods )->to( delegate )
# 	$routes->route(	$data->[0] )->via( @methods )->to( $symbol );

# }

sub Anno : ATTR {
	my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;
	print Dumper(@_);
	#no strict 'refs';
	#*{ $package . '::' . *{ $symbol }{ NAME } } = sub {
	no warnings 'redefine';
	*{ $symbol } = sub {
		my $return;
		print "About to execute $package\::" . *{ $symbol }{NAME} . " ...\n";
		$return = $referent->(@_);
		print "... $package\::" . *{ $symbol }{NAME} . " finished executing\n";
		$return;
	}
}

1;