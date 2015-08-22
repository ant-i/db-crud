#!/usr/bin/env perl

package Forge;

# for fast debugging
use Data::Dumper;

# Base package
use Mojo::Base 'Mojolicious';

use Log::Any qw[$log];

# For working with paths of current working directory
use Cwd;
use File::Basename qw[fileparse];
use File::Spec::Functions qw[catdir catfile splitpath];

use Log::Any::Adapter ('Stdout');

# Is defined on startup
my $application = undef;

sub application { my $app = pop;
	if ($app) {
		$application = $app;
	}

	return $application;
}

#
# Called on application start-up
#
sub startup {
	# http://mojolicio.us/perldoc/Mojolicious
	my ($this) = @_;

	# Define application to get later from isolated from this context scripts
	application $this;
	
	# Load configuration for mojo
	$this->load_configuration; #!
	$this->init_routes; #!
	$this->init_plugins; #!
	$this->secrets( $this->config->{ secrets } ); #!
}

sub load_configuration {
	my ($this) = @_;
	my $config_path = $ENV{APP_CONFIGURATION};
	my @files = ('app', 'chunks', 'routes');

	# Load configuration from each file to mojolicious context
	my %merged = ();
	for my $f (@files) {
		# Try to load configuration files
		TRY: {
			local $@;
			my $content = eval {
				my $path = Cwd::abs_path( catfile( $config_path, $f . CONF_EXTENSION() ));
				require $path;
			};

			# Unable to load configuration file. Application may be unstable. Bail out.
			if ($@) {
				Carp::croak( "Unable to load configuration file [$f]: $@" );
				last;
			}

			# No need for additional hierarchy level for 'app.conf' file
			if ('app' eq $f) {
				%merged = ( %merged, %{ $content } );
			} else {
				$merged{ "$f" } = $content;
			}
		}
	}

	# Set configurations
	$this->config( \%merged );
}

sub init_routes {
	my ($this) = @_;
	my $config = $this->config;
	my %routes = @{ $config->{ routes } };

	# Check routes for existence
	unless (scalar %routes) {
		Carp::carp( "No routes defined within configuration" );
		return;
	}

	# Set default namespace
	$this->routes->namespaces( $config->{ namespaces } );

	# Set mojolicious routes
	while (my ($uri, $route) = each %routes) {
		# Package subroutine defined under namespace to which action will be delegated
		my $delegate = $route->[0];
		# Routes are defined as array ref [ 'router', 'method 1', 'method 2' .. 'method N']
		# So we take all elements but first and consider them as request methods
		# otherwise use defaults if no methods are specified
		# See: DEFAULT_ROUTE_METHODS
		my @methods = ( @{ $route } [1 .. $#$route] ) // DEFAULT_ROUTE_METHODS();
		# Assign delegate to execute upon calling $uri with one of @methods
		$this->routes->route( $uri )->via( @methods )->to( $delegate );
		$log->debug( "ROUTE: Set route [$uri] to delegate [$delegate]" );
	}
}

sub init_plugins {
	my ($this) = @_;
	my $plugin_prefix = $this->config->{ plugin_prefix };
	my $embeds_prefix = $this->config->{ embeds_prefix };

	$this->_register_plugin_dir( $plugin_prefix ) if $plugin_prefix;
	$this->_register_plugin_dir( $embeds_prefix ) if $embeds_prefix;
}

sub _register_plugin_dir {
	my ($this, $prefix, $dh) = @_;
	# Compile dir from class prefix	
	my $dir = catdir( 
		$ENV{ LIB_PATH },
		split('::', $prefix),
		'*.pm'
	);

	# Iterate over all files except Base.pm
	my @modules = glob $dir;
	for (@modules) {
		my $class = ( fileparse($_) ) [0];
		next if $class eq 'Base.pm'; # Base module
		
		# Compile package name from prefix and class and remove the extension
		$class = "$prefix\::$class";
		$class =~ s/\.pm$//;

		# Finally register our plugin
		$this->plugin( $class );
		# Log for clarity
		$log->info( "PLUGIN: Plugin [$class] registered" );
	}
}

sub CONF_EXTENSION { '.conf' }
sub DEFAULT_ROUTE_METHODS { ( 'get', 'post', 'delete', 'put', 'head' ) }

1;