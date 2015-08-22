#!/usr/bin/env perl
package Forge::Model::Base;

use Forge::DBC;

use base qw(Rose::DB::Object);

# Establish connection method
sub init_db {
	Forge::DBC->new_or_cached;
}

1;