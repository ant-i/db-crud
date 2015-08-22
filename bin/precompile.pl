#!/usr/bin/env perl

=pod

=head1 A precompilation script

=begin text

	This script reverse engineer given databases in configuration file and creates
	models in DBS directory as well scaffolds extension file structure

=end text

=cut

#
# Use our base directory
#
use lib '../lib';

use strict;
use warnings;

use feature qw[say];

use Forge::Data::ReverseEngineer;
use Forge::DBC;
use Forge::Model;
use Log::Any::Adapter ('Stdout');
use File::Path qw[remove_tree];
use File::Spec::Functions qw[catfile catdir];

#
# Load default environment variables and settings
#
use environment;

use debug;

# Chunks configuration
my $configuration = require( catfile( $ENV{APP_CONFIGURATION}, 'chunks.conf' ));

# A collection of data sources
my @datasource    = @{ $configuration };

# Output directory for generated code
my $output_dir 	  = $ENV{ LIB_PATH };

#
# Before generating new modules, make sure to remove already generated from @INC path
#
my @clean = glob Forge::Model::R_PATH();
remove_tree @clean;

#
# Storage for mapping package -> table name
# Modified by sub module_postamble
#
my %mapping = ();

#
# Called when Rose::DB finished loading schema for table
# Here we store tablename and package name in hash above
# to access later in post_render_hook
#
sub module_postamble {
	my $meta = shift;
	$mapping{ $meta->class } = $meta->table;
	undef;
}

sub post_render_hook {
	my ($dre, $base_class, $loader, $modules) = @_;
	my $path = $dre->output_dir;

	#
	# Iterate over generated modules and modify them
	# afterwards
	#
	for my $module (@{ $modules }) {
		my ($filepath, $file) = ();
		my @path = split '::', $module;
		$file = pop @path;
		$filepath = catfile($path, @path, "$file.pm");
		
		# Slurp module contents
		open my $ro, '<', $filepath;
		my @contents = do { 
			# INPUT_RECORD_SEPARATOR
			# or IO::Handle->input_record_separator( EXPR )
			# enable "slurp" mode
			local $/; 
			<$ro> 
		};
		close $ro;
		
		# Modify module contents
		open my $wr, '+>:encoding(utf-8)', $filepath;
		for my $line ( @contents ) {
			my $table = $mapping{ $module };

			#
			# Create manager class in place of generated module to access without additional imports
			# 
			$line =~ s/\b1;\s/__PACKAGE__->meta->make_manager_class('$table');\n1;/;
			print $wr $line;
		}

		close $wr;

	}
	
}

#
# Create references to table objects from each database given
# under lib folder ./Forge/Model/R
# and subdirectories with each database.
# 
# Each database is registered in Forge's database collection (DBC)
# and is available for usage by importing Forge::Model::R::DATABASE_NAME
#
for my $ds ( @datasource ) {
	say "Loading sources " . $ds->{ name } . ' ... ';
	
	# namespace
	my $ns = $ds->{ ns };
	
	# Database entry
	my $entry = Forge::DBC->register( $ds->{ datasource } );
	
	# Database reverse engineering
	my $dre = Data::ReverseEngineer->new(
		db => $entry,
		module_prefix => 'Model::R::' . ucfirst( $ds->{ ns } ),
		module_postamble => \&module_postamble,
		post_render_hook => \&post_render_hook
	);

	# Generate models from database
	$dre->output_dir( catdir( $ENV{ DBS_PATH }) );
	$dre->process;
	
	say "... done loading sources " . $ds->{ name };

	say 'Scaffolding CRUD extension...';

	# Scaffold database extension
	make_dir( $ns, 'Controller' );
	make_dir( $ns, 'public' );
	make_dir( $ns, 'templates' );

}

sub make_dir {
	mkdir( catdir( $ENV{ DBS_PATH }, @_ ) );
}

sub make_sample_controller {

}

sub SAMPLE_CONTROLER { my ($ns) = @_;
	<<CTRL
#!/usr/bin/env perl

# Controller package name
package $ns::Controller::Main;

# Base mojo controller
use Mojo::Base 'Mojolicious::Controller';

sub main {

}

CTRL
;

}