#!/usr/bin/env perl

package Util::Lang;

sub make_accessors {
	my $package = shift;
	# Invoked via referencing ->
	$package = shift if ($package eq __PACKAGE__);
	
	my @fields 	= @_;
	
	#Condition::not_empty( $package );
	#Condition::array_ref( $fields, "[fields] parameter must be an array ref, [" . ref($fields) . "] given" );

	for my $f ( @fields ) {
		my $sub = "${package}::${f}";
		*{ $sub } = sub {
			# Accessor function body
			# Does not accepts more than one argument as a setter
			# If you want more logic - create your own accessor, don't be a lazy-ass
			my ($self, $value) = @_;
			if (@_ == 2) {
				$self->{ $f } = $value;
			}

			$self->{ $f };
		}
	}
}

1;