package Rose::DB::Utils;

our $VERSION = '0.1';

=pod

=head1 NAME
	
Rose::DB::Utils

=head1 VERSION

0.1

=head1 SYNOPSIS

=head1 DESCRIPTION

Provides utility functions for both Rose::DB, Rose::DB::Object, etc...
For Rose::DB packages.
Mainly simplifying work with metadata and other boilerplate when working with Rose::DB

=cut

use List::Util qw[first];
use Data::Dumper;
use Rose::DB::Object::ConventionManager;

use Forge::DBC;
use Forge::Model;

=pod

=head2
	my $fk = find_foreign_key( 'key_column', $rose_db_meta );

=over 4

=item	$key_column		Key column of foreign key

=item	$meta			Rose::DB::Object::Metadata

=back

Find foreign key by its key column.

Returns Rose::DB::Object::Metadata::ForeignKey if found or undef otherwise

=cut
sub find_foreign_key {
	my ($key_column, $meta) = @_;
	my @foreign_keys = $meta->foreign_keys;
	first {
		# Find first foreign key which matches key_column association
		$_ if grep /^$key_column$/i, keys $_->key_columns;
	} @foreign_keys;
}

sub is_foreign_key {
	defined find_foreign_key @_;
}

sub list_domains {
	my ($ns, $with_class_prefix) = @_;
	my $db = Forge::DBC->get_db($ns);
	my $cm = Rose::DB::Object::ConventionManager->new;
	my @tables = $db->list_tables;
	my $prefix = $with_class_prefix ? (Forge::Model::R_PREFIX() . '::') : '';
	
	@tables = map {
		$cm->table_to_class($_, $prefix);
	} @tables;

	wantarray ? @tables : \@tables;
}

1;