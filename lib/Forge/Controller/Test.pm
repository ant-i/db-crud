#!/usr/bin/env perl

package Forge::Controller::Test;

use Forge::Base;

# Base mojo controller
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

use Rose::DB::Utils;

sub main {
	my ($this) = @_;
	
	my $domains = Rose::DB::Utils::list_domains('Bt');

	$this->render(text => Dumper($domains));

}

1;