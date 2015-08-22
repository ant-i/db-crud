#!/usr/bin/env perl

# Generated at [Sat Aug 22 19:22:57 2015];

package Model::R::ToPay;

use Forge::DBC;
use base qw(Rose::DB::Object);

Forge::DBC->register(
driver => 'pg', 
domain => 'default',
 type => 'Postgres',
 dsn => 'dbi:Pg:dbname=gate;host=localhost;port=5432',
 username => 'postgres',
 password => 'Qwerty1',
 connect_options => {
  'Warn' => 0,
  'AutoCommit' => 1,
  'RaiseError' => 1,
  'ChopBlanks' => 1,
  'PrintError' => 1
}
);

sub init_db {
	Forge::DBC->new_or_cached( domain => 'default', type => 'Postgres' );
}

1;
