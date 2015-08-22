package Forge::Controller::Dashboard;


# Base mojo controller
use Mojo::Base 'Mojolicious::Controller';

use Forge::DBC;

use Data::Dumper;

#
# action for:
# 	/
#
sub main {
	my $this = shift;
	my $chunks = $this->config->{ chunks };

	$this->render( 'index', ( chunks => $chunks ) );
}

#
# Action for:
# 	/tables
#
sub tables {

}

1;