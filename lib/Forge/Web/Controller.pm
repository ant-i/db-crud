package Forge::Web::Controller;

# Name spaces and domain paths
use Forge::Names;

use Forge::Data::Transform;

sub from_stash {
	my $self = shift;
	return map { 
		$self->stash($_) 
	} @_;
}

sub err {
	my ($self, $status, $flash_code, @params) = @_;

	# Set Response status code
	$self->res->status( $status );

	# Set flash message or message code
	$self->flash( message => $flash_code, params => \@params );

	# Render error page
	$self->render(text => 'Err');
}

1;