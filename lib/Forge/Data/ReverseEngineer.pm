#!/usr/bin/env perl

package Data::ReverseEngineer;

our $VERSION = '0.9';

=pod

=head1 NAME

Data::ReverseEngineer

Wrapper around Rose::DB::Object::Loader with flavor for Forge

=head1 VERSION

version 0.9

=head1 SYNOPSIS

	Rose::DB->register_db(
		domain => 'foo',
		type => 'default',
		driver => 'Sqlite',
		database => 'my-sqlite.db'
	);
	
	my $db = Rose::DB->new(domain => 'foo');
	my $re = Reverse::Engineer->new(
		db => $db,
		output_dir => '/to/be/changed',
		module_prefix => 'Foo::Bar'
	);

	$re->output_dir('/here/please');
	$re->module_prefix('Foo::Bar');
	# This will do too
	$re->module_prefix('Foo::Bar::');

	my $modules = $re->process;
	say Dumper($modules);
	
	use lib '/here/please';
	use Foo::Bar;

	my $foo = Foo::Bar->new;
	$foo->dbh( do {
		# ...
	});

	use Foo::Bar::MyTable;

	my $row = MyTable->new(id = 1);
	my $bool = $row->load;


=head1 DESCRIPTION

Generate Rose::DB::Object modules with base by given DSN chunks in config file
Used to construct reversed ORM references to produce easy-go-round scaffolding

=cut

use File::Path;
use File::Spec;
use File::Spec::Functions qw[catdir catfile rel2abs];

use Rose::DB;
use Rose::DB::Object;
use Rose::DB::Object::Loader;

use Data::Dumper;
use Log::Any;
use Util::Lang;
use Assertion;

# For dying gracefully
use Carp;

# Our logger for debugging information
our $log = Log::Any->get_logger( category => 'debug' );

# Before pre-compile time
BEGIN {
	# Make accessors and mutators
	Util::Lang->make_accessors( __PACKAGE__, 
		#
		# Base package for generated modules
		# If DB has table `A` and base_package was specified as `Foo::Bar`,
		# Loader will generate module under directory `Foo/Bar/A` with package `A` if prefix_classes is set to 0
		# or under package `Foo::Bar::A` if prefix_classes is set to 1.
		# 
		# And Base module will be `Foo::Bar` unless `base_class` is specified
		#
		"module_prefix",
		#
		# A class name for base package
		#
		"base_class",
		#
		# Where to write modules in file-system
		#
		"output_dir",
		#
		# Should we also prefix packages with base_class
		#
		"prefix_classes",
		#
		# Preamble for generation of module.
		# See Rose::DB::Object::Loader
		#
		"module_preamble",
		#
		# Postamble for generation of module.
		# See Rose::DB::Object::Loader
		#
		#
		"module_postamble",
		#
		# A code ref wich will be called when all modules are generated
		# Passes reference of Data::ReverseEngineer, name of base class, Rose::DB::Object::Loader and array ref of modules generated
		#
		"post_render_hook",
		#
		# [BOOL]
		# Should managers classes be generated
		#
		"with_managers"
	);
}

#
# (hash) -> Data::ReverseEngineer
# 
# Creates new instance of ReverseEngineer
# 
# Requires parameter:
#  - db
#  
# Optional parameters are:/
#  - output_dir
#  - module_prefix
#
sub new { # $ (%)
	my $class = shift;
	$class = ref($class) || $class;
	# Parameters of connection
	my %params = @_;

	my $database = $params{ db };
	unless( $database ) {
		Carp::croak( "Forge::Data::ReverseEngineer requires [db] parameter to create an instance" );
	}

	# Bless object with reference to this package
	# And do unholy things with it
	my $inst = bless {}, $class;
	# Set reference to Rose::DB
	$inst->db( $database );
	
	# Set class prefix as well as base class
	$inst->base_class( $params{ base_class } // '' );
	$inst->module_prefix( $params{ module_prefix } );
	$inst->module_preamble( $params{ module_preamble } );
	$inst->module_postamble( $params{ module_postamble } );
	$inst->prefix_classes( $params{ prefix_classes } );
	
	# Set output directory
	$inst->output_dir( $params{ output_dir } );
	$inst->with_managers( $params{with_managers} );
	$inst->post_render_hook( $params{ post_render_hook } );
	
	# Return blessed instance
	$inst;
}

=pod

=head2 
	my $rose_db = $self->db;

=head2 
	$self->db( $db );

=over 4

=item $db 	Rose::DB OR hashref

=back

Mutator and accessor for DB key of ReverseEngineer.

	$self->db( Rose::DB->new );
	$self->db({
		dsn => 'dbi:Pg:dbname=my_db'
	});

=cut
sub db {
	my $self = shift;
	unless (@_) {
		return $self->{ db };
	}

	my $db  = shift;
	my $ref = ref $db;

	print Dumper( $db ) . "\n";
	print Dumper( $ref ) . "\n";

	if ($ref eq 'HASH') {
		$self->{ db } = Rose::DB->new( %{ $db } );
	}
	elsif ($ref && $db->isa('Rose::DB')) {
		$self->{ db } = $db;
	}
	elsif ($ref && $db->isa('Rose::DB::Registry::Entry')) {
		$self->{ db } = Rose::DB->new( domain => $db->domain, type => $db->type );
	}
	else {
		Carp::croak("Expected first argument to be either hash ref, Rose::DB ref or Rose::DB::Registry::Entry ref - [$ref] given");
	}
}

=pod

=head2 my $arrayref = $self->process(%params)

=over 4

=item %params 	Additional parameters for generating modules

=over 4

=item preamble

=item postamble

=back

=back

Loads database schema as Rose::DB::Objects to represent db
structure in perl scripts.

B<Has side effect>

=cut
sub process { # \@ (%)
	my $inst = shift;
	my %args = @_;

	$log->debug("Start process: construct schema modules from database in domain [" . $inst->db->domain . "] and type [" . $inst->db->type . "] ...");

	# First make base class
	my $base = $inst->make_base; #!
	my $loader = $inst->create_loader( $base, %args );

	$log->debug(" ... base class [$base] created ... ");
	my $modules = $loader->make_modules; #!
	$log->debug("... finished creating schema modules.");

	if ('CODE' eq ref $inst->post_render_hook) {
		$inst->post_render_hook->($inst, $base, $loader, $modules);
	}

	return $modules;
}

=pod

=head2 my $loader = $self->create_loader($class, %args)

=over 4

=item $class

=item %args

=back

Creates blessed reference for Rose::DB::Object::Loader with predefined
and pre-made base class

=cut
sub create_loader {
	my ($inst, $class, %args) = @_;
	my $module_dir = $inst->{ base_path };
	my $class_prefix = $inst->module_prefix;
	
	$Rose::DB::Object::Loader::Debug = 1;
	Rose::DB::Object::Loader->new(
		base_class => $class,
		module_dir => $inst->output_dir,
		#class_prefix => $inst->prefix_classes ? $inst->module_prefix : '',
		class_prefix => $class_prefix,
		
		# Database connection instance
		db => $inst->db,

		# Ambles
		module_preamble => $args{ module_preamble } // $inst->module_preamble,
		module_postamble => $args{ module_postamble } // $inst->module_postamble,
		
		force_lowercase => 1,
		with_managers => $inst->with_managers,
	);
}

=pod

=head2 $self->make_base;

Creates a base class module for Rose::DB::Objects to be based upon.
Saves module class in given B<$self->output_dir> and B<$self->module_prefix>

Assume that class prefix is C<Bar::Baz> and output dir is C</var/lib/foo>
than base class will be in C</var/lib/foo/Bar/Baz.pm>

B<$self->module_prefix is required. Carps if no class prefix is specified>

Uses cwd if output_dir is undefined

B<This function has side effect>

=cut
sub make_base {
	my $inst = shift;
	# Get class prefix. It will serve as path
	my $prefix = $inst->module_prefix;
	
	Assertion::must( $prefix, "module_prefix must be defined for module generation" );
	# Remove last occurance of double colon if it exists
	$prefix =~ s/::$//;

	# Make and fetch path to base class as well as path for loaded schema modules
	my $path = $inst->make_base_path( $prefix ); #!
	my $tmpl = R_BASE_TEMPLATE( $inst->db, $prefix );

	$log->debug("Writing base class $prefix to file $path");
	TRY: {
		local ( $@, $f ) = ();
		my $module_path = $path . '.pm';
		# Write module to file
		eval {
			open $f, '+>:encoding(utf-8)', $module_path;
			print $f $tmpl;
			close $f;
		};

		if ($@) {
			carp("Unable to write base file to $path.pm: $@");
		}
	}

	$log->debug("Base class [$prefix] created at [$path.pm]");
	# Import newly generated base class
	require "$path.pm";
	$prefix->import; # Since $prefix actually holds fully-qualified package name

	$prefix;
}

=pod

=head2 $self->make_base_path($package)

=over 4

=item $package 		Name of package for base class

=back

Creates path for base class module of [$package] within [output_dir]

B<This function has side effect>

=cut
sub make_base_path { # $ ($)
	my ($inst, $package) = @_;
	# Get base path and create it
	my $output = $inst->output_dir;
	# Compile path from package to absolute desitnation
	my $path = rel2abs( catdir( $output, split '::', $package ));
	$log->debug( "ReverseEngineer will create modules at [$path]..." );
	# Create directory if it doesn't exists
	unless (-e $path) {
		File::Path::make_path($path) or carp("Unable to create path [$path]: $!");
	}

	# Prevent duplication of path by module last name
	# i.e.
	# Base class - Foo::Bar
	# Mod prefix - Bar
	# Output dir - /var/
	# 
	# result - /var/Foo/Bar/Bar
	#$inst->{ base_path } = substr($module_dir, 0, -(length($inst->module_prefix) + 1));
	$inst->{ module_path } = $path;
	return $path;
}

=pod

=head2 R_BASE_TEMPLATE($rdb, $namespace)

=over 4

=item $rdb 			L<Rose::DB> reference

=item $namespace	package name of base class

=back

Returns perl module contents for given B<$rdb> (Rose::DB) reference and given B<$namespace> (as in package).
The module is assumed to be a base package for given database to serve as entry point and retrieving
database handler and interface. (DBI)

Module is based from Rose::DB::Object and uses Forge::DBC

	my $rdb = Rose::DB->new;
	my $template = R_BASE_TEMPLATE( $ )

=cut
sub R_BASE_TEMPLATE { # $ ($, $)
	my ($db, $namespace) = @_;
	my $type = $db->type;
	my $domain = $db->domain;
	my $register_db_tpl = R_REGISTER_DB_TEMPLATE( $db );
	my $timestamp = localtime;

	<<R
#!/usr/bin/env perl

# Generated at [$timestamp];

package $namespace;

use Forge::DBC;
use base qw(Rose::DB::Object);

$register_db_tpl;

sub init_db {
	Forge::DBC->new_or_cached( domain => '$domain', type => '$type' );
}

1;
R
;
}

=pod

=head2 my $register_tpl = R_REGISTER_DB_TEMPLATE($db)

=over 4

=item $db 	ISA Rose::DB

=back

Creates a perl script which registers database at Forge::DBC for
further usage with Rose::DB::Objects

=cut
sub R_REGISTER_DB_TEMPLATE {
	my ($db, $tpl) = (shift, "Forge::DBC->register(\n");
	
	$tpl .= 'driver => \'' . $db->driver . "', \n";
	$tpl .= 'domain => \'' . $db->domain . "',\n ";
	$tpl .= 'type => \'' . $db->type . "',\n ";
	$tpl .= 'dsn => \'' . $db->dsn . "',\n ";
	
	if (defined $db->username) {
		$tpl .= 'username => \'' . $db->username . "',\n ";
	}
	
	if (defined $db->password) {
		$tpl .= 'password => \'' . $db->password . "',\n ";
	}

	CONNECT_OPTS: {
		local $Data::Dumper::Terse = 1;
		my %opts = $db->connect_options;
		$tpl .= "connect_options => " . Dumper(\%opts);
	}
	
	$tpl .= ")";
	return $tpl;
}

1;