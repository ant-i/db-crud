#!/usr/bin/env perl

#
# Database collection package
# Registers arbitrary amount of databases to use in application distributed by namespaces.
# 
# Database collections is defined in chunks.conf configurationfile
# and is initialized during startup.
# 
# Before application startup however, connections are tested and databases are reverse-enginered
# into Rose::DB::Object modules into Forge/Model/R directory.
# 
# @see ./bin/precompile.pl
# @see ./bin/run.pl
# @see ./Forge/Data/ReverseEngineer.pm
#
package Forge::DBC;

# Extend from Rose::DB
use base Rose::DB;
# For debugging
use Data::Dumper;

use Assertion;
use Log::Any;
use Rose::DB::Registry;
use Rose::DB::Registry::Entry;

use Carp;

use Forge::Model;
use Forge::Names;

# Serialize Forge::DBC
our @ISA = qw/Rose::DB/;

our $log = Log::Any->get_logger( category => 'debug' );

# Setup default domain
__PACKAGE__->default_domain( $ENV{ APP_ENVIRONMENT } // 'default' );
# Setup default type
__PACKAGE__->default_type( 'main' );

#
# Registers database instance in collection for later use
#
sub register {
	my $self = shift;
	my %attr;
	if (1 == scalar(@_) && ref($_[0]) eq 'HASH' ) {
		%attr = %{ $_[0] };
	} else {
		%attr = @_;
	}

	# Set default domain if not set otherwise
	$attr{ domain } //= $ENV{ APP_ENVIRONMENT };
	
	my $entry = Rose::DB::Registry::Entry->new( %attr );
	unless ($self->registry->entry_exists( domain => $entry->domain, type => $entry->type )) {
		$self->register_db( $entry );
		$log->debug( "Registered new DB entry [$entry] with domain [" . $entry->domain . "] and type [" . $entry->type . "]" );
	}

	return $entry;
}

sub get_db {
	my ($self, $ns) = @_;
	Assertion::must($ns, "A namespace parameter must be given");
	my $class = Forge::Names->package_of(Forge::Model::R_PREFIX(), $ns);

	croak "Unable to get database instance of namespace [$ns]. Could not load required module" 
		unless $class;

	$class->init_db;
}


1;