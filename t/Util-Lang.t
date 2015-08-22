#!/usr/bin/env perl

use lib '../lib';
use Test::More;

{
	package Foo;

	use Util::Lang;

	BEGIN {
		Util::Lang::make_accessors( Foo, "a", "b", "c" );
	}

	sub new {
		my $class = shift;
		$class = ref($class) || $class;
		bless {}, $class;
	}

	1;
}

my $foo = Foo->new;

no strict 'refs';
my @subs = grep { defined &{ "Foo\::$_" } } keys %{ "Foo\::" };

ok( 4 == scalar @subs, "Package Foo has 4 methods 3 of which are accessors" );
ok( $foo->can("a"), "Foo can [a] sub" );
ok( $foo->can("b"), "Foo can [b] sub" );
ok( $foo->can("c"), "Foo can [c] sub" );

my $a_val = $foo->a;
ok( !defined($a_val), "Foo [a] accessor returned undefined value" );

is( $foo->a( 123 ), 123, "Foo [a] value is set to 123");

$a_val = $foo->a;
is( $a_val, 123, "Foo [a] accessor returned [123] value");

my $another_foo = Foo->new;
ok( !defined($another_foo->a), "Another new instance of Foo must not have a value [a]");
is( $foo->{a}, 123, "Directly accessing value of Foo [a] which should be [123]");

done_testing();