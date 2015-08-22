#!/usr/bin/env perl

# Generated at [Fri Feb  6 10:39:34 2015];

package Forge::Model::R::Oos;

use Forge::DBC;
use base qw(Rose::DB::Object);

Forge::DBC->register(
driver => 'pg', 
domain => 'default',
 type => 'Postgres-OOS',
 dsn => 'dbi:Pg:dbname=webmerchant;host=192.168.88.182;port=5432',
 username => 'postgres',
 password => 'Qwerty1',
 connect_options => {
  'Warn' => 0,
  'AutoCommit' => 1,
  'RaiseError' => 1,
  'ChopBlanks' => 1,
  'PrintError' => 1,
  'pg_enable_utf8' => 1  # IMPORTANT FOR UNICODE DATA!
}
);

sub init_db {
	Forge::DBC->new_or_cached( domain => 'default', type => 'Postgres-OOS' );
}

1;
