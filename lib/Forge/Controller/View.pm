package Forge::Controller::List;


# Base mojo controller
use Mojo::Base 'Mojolicious::Controller';

# Generic backend
use parent qw(Forge::Web::Controller::Scaffold);

# Name spaces and domain paths
use Forge::Names;

#
# action for:
# 	/view/:namespace/:table/:id
#
# A processor for incoming request for URI
# /view/namespace/domain
# 
# Can also apply basic query
# For extensive filtering see Forge::Controller::Filter
#
sub main {
	# This instance
	my $this = shift;
	# Domain object
	my $domain = $this->load_domain;
	# Fetch ID
	my $id = $this->stash('id');

	# Check that identity was passed
	unless( $id ) {
		return err( 404, 'entry.not.found', $id );
	}

	# Instantiate domain object with given identifier and load it in try-catch block
	my $object;
	TRY: {
		local $@;
		eval {
			$object = $domain->new( id => $id );
			$object->load;
		};

		# Render error if we failed loading object
		if ($@) {
			return err( 500, 'entry.load.error', $id, $@ );
		}
	}

	# Pass it down to response with additional info
	$inst->negotiate(
		item 		=> $object,
		relations 	=> $this->load_relations( $domain, $object )
	);
}

sub load_relations {
	my ($this, $domain, $object) = @_;
	return {};
}


1;