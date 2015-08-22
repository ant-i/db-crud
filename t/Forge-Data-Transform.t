#!/usr/bin/env perl

use lib '../lib';
use Test::More;
use Forge::Data::Transform;
use Data::Dumper;

my @data = (
	["Header 1", "Header 2", "Header 3"],
	[1, 2, '"3"'],
	[2, 3, 4],
	[5, 6, 7]
);

print Forge::Data::Transform->as_csv( \@data, ';', '' ) . "\n";
print Forge::Data::Transform->as_json( \@data ) . "\n";
print Forge::Data::Transform->as_json( { a => 1, b => 2, c => [1, 2, 3]} ) . "\n";