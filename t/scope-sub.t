
sub test_scope {
	print $a + $b;
}

sub test(&) {
	my $code = shift;
	print $code;
	$code->();
}

test { 
	print Dumper(caller);
}