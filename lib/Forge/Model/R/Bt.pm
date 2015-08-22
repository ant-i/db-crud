#!/usr/bin/env perl

# Generated at [Fri Jan 23 11:28:28 2015];

package Forge::Model::R::Bt;

use Forge::DBC;
use base qw(Rose::DB::Object);

Forge::DBC->register(
driver => 'mysql', 
domain => 'default',
 type => 'MySQL',
 dsn => 'dbi:mysql:database=bt;host=localhost;port=3306',
 username => 'root',
 password => 'root',
 connect_options => {
  'Warn' => 0,
  'AutoCommit' => 1,
  'RaiseError' => 1,
  'ChopBlanks' => 1,
  'PrintError' => 1
}
);

sub init_db {
	Forge::DBC->new_or_cached( domain => 'default', type => 'MySQL' );
}

1;
