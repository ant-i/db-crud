package Log::Any::Adapter::RollingMojo;

our $VERSION = '0.9';

=head1 NAME
Log::Any::Adapter::RollingMojo

=head1 VERSION
0.9

=head1 SYNOPSIS

	use Log::Any qw[$log];
	use Log::Any::Adapter

	Log::Any::Adapter->set( 'RollginFile' );

	$log->info( 'Hello log' );

=head1 DESCRIPTION

TODO

=over


=cut

use strict;
use warnings;
use warnings::register;
use feature qw[say];

# Inherit base methods
use base qw[Log::Any::Adapter::Base];
# Utility to make adapter methods
use Log::Any::Adapter::Util qw[make_method];
# Debugging facility
use Data::Dumper;
# Mojolicious logger
use Mojo::Log;
# For dying gracefully
use Carp;
# For date-time format
use POSIX;
# For manipulating FS for loggers
use File::Spec;
use File::Path;

use Assertion;

use constant DAY_IN_S => 86400;

#
# Link methods from Log::Any to Mojo::Log
# Method mapping is:
# Log::Any		Mojo::Log
# [trace]		[debug]
# [debug]		[debug]
# [info]		[info]
# [notice]		[info]
# [warning]		[warn]
# [error]		[error]
# [critical]	[fatal]
# [alert]		[fatal]
# [emergency]	[fatal]
#
SETUP: {
	#
	# Make user aware that behabiour of this logger is slightly different
	#
	warnings::warnif('redefine', 'Log::Any::Adapter::RollingMojo overrides logging methods of Log::Any::Proxy to pass array arguments instead of joined string. The behaviour of this appender is thus different');

	# Iterate over all logging methods
	foreach my $method (Log::Any->logging_methods) {
		my $mojo_method = $method;
		# Map Log::Any methods to Mojo::Log
		for ($mojo_method) {
			s/trace/debug/;
			s/notice/info/;
			s/warning/warn/;
			s/critical|alert|emergency/fatal/;
		}
		# Make Log::Any method
		make_method( $method, 
			# Make subroutine mapping to Mojo::Log $mojo_method
			make_logger( $mojo_method )
		);

		no strict 'refs';
		no warnings 'redefine';
		PROXY_METHOD_OVERRIDE: {
			*{ 'Log::Any::Proxy::' . $method } = sub {
				my ($self, $message, %args) = @_;
				$self->{ adapter }->$method($message, %args);
			};
		}
	}
}

#
#
#
sub make_logger {
	my ($method) = @_;
	# Actual logger
	sub {
		shift->_log( $method, @_ );
	}
}

sub DEFAULT_CONTEXT { "default"; }
sub DEFAULT_PATTERN { '%Y-%m-%d'; }
sub DEFAULT_FILENAME { '{context}-{pattern}.log'; }

#
# Called when Log::Any::Adapter is set for RollingMojo
#
sub init { # void ($, %)
	my ($self, %attr) = @_;
	
	# Assert attributes
	# Path and pattern must be specified
	Assertion::must( $attr{ path }, "Attribute [path] must be specified" );
	#Assertion::must( $attr{ pattern }, "Attribute [pattern] must be specified" );
	
	# Cache instantiation attributes for later
	$self->{ __attr } = \%attr;
	$self->{ level }  = $attr{ level } // 'info';

	#
	# Initialized loggers
	# RollingMojo is a Log::Any::Appender for Mojo::Log with support
	# for file rolling and nested log context (like MDC/NDC in Log4j)
	# 
	# To support log context we need to keep a collection of loggers
	# This is it
	#
	$self->{ loggers } = {};
}

sub fetch_default_context {
	my ($self, $method) = @_;
	my %attrs  = %{ $self->{ __attr } };
	my $context;

	$context = $attrs{ context };
	$context = $attrs{ category } unless $context;
	$context = $method unless $context;
	$context;
}

sub fetch_logger {
	my ($self, $context) = @_;
	my %loggers = %{ $self->{ loggers } };

	if ( not defined $loggers{ $context } ) {
		return $loggers{ $context } = $self->rotate( $context );
	}

	# Otherwise defined. Check if we should rotate logger
	my $logger  = $loggers{ $context };
	my $history = $logger->history;
	my $unix_ts = $history->[ $#$history ]->[0];

	if ($unix_ts > DAY_IN_S) {
		$loggers{ $context } = $logger = $self->rotate( $context );
	}

	$logger;
}

sub rotate {
	my ($self, $context) = @_;
	my $logpath = $self->{ __attr }->{ path } // File::Spec->catdir( $ENV{ APP_HOME }, 'log', $context );
	my $pattern = $self->{ __attr }->{ pattern } // DEFAULT_PATTERN();
	my $filename = $self->{ __attr }->{filename} // DEFAULT_FILENAME();

	for ($filename) {
		my $level = $self->{ level };
		s/\{level\}/$level/;
		s/\{pattern\}/$pattern/;
		s/\{context\}/$context/;
	}

	# Convert to absolute path
	$logpath = File::Spec->rel2abs( $logpath );
	unless(-e $logpath) {
		File::Path::make_path( $logpath, { verbose => 1 });
	}

	# Make new logger
	Mojo::Log->new(
		level => $self->{ level },
		path  => File::Spec->catfile( $logpath, POSIX::strftime($filename, localtime))
	);
}

sub _log {
	my ($self, $method, $message, %attrs) = @_;
	my $context = $attrs{ context } || $self->fetch_default_context( $method );
	my $logger = $self->fetch_logger( $context );

	$logger->$method( $message );
}

1;

__END__;