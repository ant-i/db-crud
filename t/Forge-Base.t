use lib '../lib';
use Data::Dumper;

{
	package Foo;
	use base Forge::Base;
	use Data::Dumper;

	sub new {
		my ($class) = @_;
		$class = $class || ref $class;
		bless {}, $class;
	}

	sub foo : Anno( 'xxxx' ) {
		print "Hello!\n" . Dumper(@_) . "\n";
	}
}


Foo::foo();
my $foo = Foo->new;
print Dumper($foo);
my $sub = \&Foo::foo;
print Dumper($sub);
$sub->($foo);

sub t {
	my $s = shift;
	print "T: " . Dumper($s);
}

my $t = sub{ t(1) };
$t->();
