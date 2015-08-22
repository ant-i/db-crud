package Forge::Web::Controller::Scaffold;

use parent qw(Forge::Web::Controller);

# Name spaces and domain paths
use Forge::Names;

#
# Loads data-base table representation in form of a package
# along with table metadata
#
sub load_domain {
	my $inst = shift;
	# Get namespace and domain name from URI
	my ($ns, $dm) = $inst->from_stash( 'ns', 'domain' );
	# Load package of namespace and domain
	my $package = Forge::Names->package_of( MODEL_PREFIX(), $ns, $dm );
	# Check that domain was loaded
	unless ($package) {
		return $inst->err( 401 => "Unrecognized domain of [$ns\::$dm]" );
	}
	
	# Load foreign-keys
	my @keys = $package->meta->foreign_keys;
	if (0 < scalar @keys) {
		for(@keys) {
			Forge::Names->package_of( $_->class );
		}
	}

	# Return package
	$package;
}

sub MODEL_PREFIX {
	('Forge', 'Model', 'R');
}

1;