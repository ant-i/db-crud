package Forge::Embed::Rose;

use Mojo::Base 'Mojolicious::Plugin';
use Mojo::ByteStream;

use Data::Dumper;

use Carp;

use Rose::DB::Utils;

sub register {
	my ($self, $app) = @_;
	$app->helper( 'each_row' => \&each_row );
	$app->helper( 'field_value' => \&field_value );
	$app->helper( 'link_to_object' => \&link_to_object );
}

sub _meta {
	my ($key, $meta) = @_;
	# Get column names
	if ( 'columns' eq $key ) {
		return $meta->column_accessor_method_names;
	}

	# Get foreign keys
	if ( 'fk' eq $key ) {
		return $meta->foreign_keys;
	}

	# Get primary keys
	if ( 'pk' eq $key ) {
		return $meta->primary_keys;
	}

	croak( "Undefined information key: [$key]" );
}

sub find_fk {
	my ($name, @keys) = @_;
	my $fk = shift(@keys);
	if ($fk->name eq $name) {
		return $fk;
	}

	if (scalar @keys) {
		return find_fk($name, @keys);
	}

	return undef;
}

sub field_value {
	my ($self, $item, $column_name) = @_;
	my ($meta, $value) = ($item->meta, $item->$column_name);
	my $fk = Rose::DB::Utils::find_foreign_key( $column_name, $meta );
	if ($fk) {
		return $self->link_to_object( $fk => $value );
	}
	
	return $value;
}

sub link_to_object {
	my ($this, $object, $key_value) = @_;
	my @segments = split '::', $object->class;
	my ($ns, $dn) = @segments[-2 .. -1];

	$this->link_to($key_value => "/view/$ns/$dn/$key_value");
}

sub each_row {
	my ($this, $meta, $rows, $cb) = @_;
	my $content = "";
	my $row_num = 0;
	my $columns = _meta columns => $meta;

	unless (ref($cb)) {
		for (@{ $rows }) {
			$content .= $this->render(
				template  => "$cb",
				partial   => 1,
				# Template variables
				__columns => $columns,
				__item 	  => $_,
				__row_num => ( $row_num ++ ),
				__is_odd  => ( $row_num % 2 ) == 0,
			)
		}
	}

	print Dumper(Rose::DB::Utils::find_foreign_key( 'post_address_id', $meta ));
	
	# TODO $cb may also be code-block as in
	# each_row $rows => begin
	# 	<p>$_->name</p>
	# end;
	
	# Prevent escaping
	Mojo::ByteStream->new($content);
}

1;