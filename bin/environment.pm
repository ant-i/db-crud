#!/usr/bin/env perl

use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir catfile splitdir);
use Cwd qw(abs_path);

# 
# Populate INC perl library with our packages to have them on runtime 
# without specifying PERL5_LIB in environment variables
# 
# Source directory has precedence
# 
use lib abs_path('../lib');

#
# DBS directory will house extensions to base CRUD scaffolding application
#
use lib abs_path('../dbs');

#
# Set application environment to initialize proper configuration file
#
$ENV{APP_ENVIRONMENT} = shift(@ARGV);

#
# Get absolute path to app home directory
#
my $abs_path = dirname(abs_path(__FILE__));

#
# Set application home
#
$ENV{APP_HOME} = abs_path(catdir($abs_path, ".."));

#
# Set application lib path
#
$ENV{LIB_PATH} = catdir( $ENV{ APP_HOME }, 'lib' );

#
# Set application extensions path
#
$ENV{DBS_PATH} = catdir( $ENV{ APP_HOME }, 'dbs' );

#
# No environment set. Resume to default
#
$ENV{APP_ENVIRONMENT} //= 'default';

#
# Set configuration file path for given environment
#
$ENV{APP_CONFIGURATION} = abs_path(catdir($ENV{APP_HOME}, 'conf', $ENV{APP_ENVIRONMENT}));
$ENV{APP_CONFIGURATION} =~ s/\.\././;

1;