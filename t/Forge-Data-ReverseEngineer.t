#!/usr/bin/env perl

# TODO - More tests

use lib '../lib';
use Rose::DB;
use Data::Dumper;
use Test::More;
use Forge::Data::ReverseEngineer;
use File::Path qw(remove_tree);

use Log::Any::Adapter ('Stdout');

{
	package Test::DB;

	use base Rose::DB;

	__PACKAGE__->register_db(
		domain => 'test',
		type => 'sqlite',
		driver => 'Sqlite',
		database => './test.db'
	);

	__PACKAGE__->register_db(
		domain   => 'test',
		type     => 'pg',
		driver   => 'Pg',
		host     => '127.0.0.1',
		port     => 5432,
		database => 'gate',
		username => 'postgres',
		password => 'Qwerty1',
		server_time_zone => 'UTC',
		connect_options  => { 
			'pg_enable_utf8' => 1
		}
	);

	__PACKAGE__->default_domain( 'test' );
	__PACKAGE__->default_type( 'sqlite' );

	sub init_db {
		__PACKAGE__->new_or_cached;
	}
}

# dbi:SQLite:dbname=dbfile

use Rose::DB::Registry::Entry;

my $rdb = Test::DB->new(domain => 'test', type => 'sqlite');
my $dre = Data::ReverseEngineer->new( 
	db => $rdb,
	module_prefix => 'Test::Model::',
	prefix_classes => 0
);


$dre->output_dir( './tmp' );
$dre->process;

# Since we're testing at runtime generation. Eval is natural here
use lib './tmp';
eval "require Test::Model";
eval "require Test::Model::MyTest";

my $mt = Test::Model::MyTest->new( id => 1 );
$mt->load;

is( $mt->var_field, 'asdasd', 'Check value of column [VAR_FIELD] from loaded row by ID=1' );
is( $mt->int_field, 1, 'Check value of column [INT_FIELD] from loaded row by ID=1' );
is( $mt->meta->primary_key->columns->[0]->name, 'ID', 'Check meta-data: Primary key is a single column [ID]' );
ok( $mt->meta->column('NUM_UNIQUE')->not_null, 'Check Not-null constraint for [NUM_UNIQUE]' );
is( $mt->meta->unique_keys->[0]->columns->[0]->name, $mt->meta->column('NUM_UNIQUE')->name, 'Check UNIQUE constraint for [NUM_UNIQUE]' );

my $triggered = 0;
$mt->meta->column('NUM_UNIQUE')->add_trigger(on_get => sub { $triggered = 1; });
$mt->num_unique;

is( $triggered, 1, "Check triggers" );

# Clean tmp folder
remove_tree glob "./tmp/*";

done_testing();