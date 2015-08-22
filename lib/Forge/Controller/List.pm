#!/usr/bin/env perl

package Forge::Controller::List;

our $VERSION = '0.7';

# Base mojo controller
use Mojo::Base 'Mojolicious::Controller';

# Generic backend
use parent qw(Forge::Web::Controller::Scaffold);

# Name spaces and domain paths
use Forge::Names;

# For generating hyper-reference links across CRUD scaffold and Forge
use Forge::Web::HREF;

use Data::Dumper;

#
# action for:
# 	/list/:namespace/:table
#
# A processor for incoming request for URI
# /list/namespace/domain
# 
# Can also apply basic query
# For extensive filtering see Forge::Controller::Filter
#
#sub main : Action( route => '/:ns/list/:domain', negotiate => 1 ) {
sub main {
	my $inst = shift;
	# Get domain name from URI and load its package
	my $domain = $inst->load_domain;
	# Continue loading list
	$inst->list( $domain, "$domain\::Manager" );
}

#
# Actual list method for fetching list of data items
# using RoseDB Manager package
#
sub list {
	# Current instance + Domain class + Rose DB data manager
	my ($inst, $domain, $manager) = @_;
	# Table name
	my $table_name = $domain->meta->table;
	# List subroutine
	my $list_sub   = $manager->can("get_$table_name");
	# Count subroutine
	my $count_sub  = $manager->can("get_$table_name\_count");
	# Check that we're really dealing with manager
	unless ($list_sub) {
		return $inst->negotiate( error => "Missing [list] method for manager [$manager] of domain [$domain]" );
	}

	# TODO apply query
	
	# Render data
	$inst->negotiate(
		items => $manager->$list_sub( limit => 100 ),
		count => $manager->$count_sub(),
		meta  => $domain->meta
	);
}

#
# Returns a list view menu items available
#
sub menu_items {
	[
		{ label => "menu.list.new", link => Web::HREF->link($_[0], "new") },
		{ label => "menu.list.del", link => Web::HREF->link($_[0], "del") },
	]
}

=pod

=head2 $this->negotiate( foo => 'bar', bar => 'foo' );

=over 4

=item 	%data 	Data to pass to response

=back

Outputs list data to HTTP response in format desirable by client.
Reads Accept header to list preferences by client.
Alternatively client may also force content type by specifying it in URI.

Note that only HTML view format can handle rendering of
menu-items and other UI elements.

Formats that serve only as data-transfer only passes list items

=cut
sub negotiate { 
	my $inst = shift;
	my %data = @_;

	# Handle negotiations
	my $accept = $inst->req->headers->accept;

	$inst->render( 'crud/list', %data );
	#$inst->render( text => '' . Dumper(%data) );
}

1;