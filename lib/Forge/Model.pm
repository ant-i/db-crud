package Forge::Model;

use File::Spec::Functions qw[catdir];

my @R_PREFIX_SEGMENTS = ('Forge', 'Model', 'R');
my $R_PREFIX = join '::', @R_PREFIX_SEGMENTS;
my $R_PATH = catdir($ENV{ LIB_PATH }, @R_PREFIX_SEGMENTS);

sub R_PREFIX_SEGMENTS { @R_PREFIX_SEGMENTS; }
sub R_PREFIX { $R_PREFIX; }
sub R_PATH { $R_PATH; }

sub domains {
	my $ns = shift;
	my $scan_dir = catdir(R_PATH, "*.pm");
	map {
		$_ =~ s/^$R_PATH//;
		$_ =~ s/\.pm&//;
		return $_;
	} glob $scan_dir;
}

sub domain_packages {
	map { R_PREFIX() . "\::$_" } domains shift;
}

sub namespaces {
	grep { -d $_ } glob R_PATH();
}