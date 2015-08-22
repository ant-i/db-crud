#!/usr/bin/env perl

package Forge::Data::Transform;

# for JSON transform
use JSON;

use Data::Dumper;

# Cache json instance
my $json = JSON->new;

sub DEFAULT_CSV_DELIMITER { ';' }
sub DEFAULT_CSV_QUOTES 	  { '"' };

sub as_json { # $ (\%|\@)
	$json->encode( pop );
}

sub as_xml {
	
}

sub as_csv { # $ (\@, $, $)
	my ($data, $delimiter, $quotes) = _selfless(@_);
	$has_headers //= 1;
	$delimiter   //= DEFAULT_CSV_DELIMITER;
	$quotes      //= DEFAULT_CSV_QUOTES;

	my @rows = @{ $data };
	my @out  = ();
	
	for my $row ( @rows ) {
		push @out, join $delimiter, map { 
			$quotes . _escape($_, $quotes) . $quotes 
		} @{ $row };
	}

	join "\n", @out;
}

sub as_yaml {

}

sub _escape {
	my ($str, $quote) = @_;
	$str =~ s/$quote/\\$quote/g if $quote;
	$str;
}

sub _selfless {
	shift if $_[0] eq __PACKAGE__; 
	@_;
}

1;