use lib '../lib';
use feature qw[say];
use Data::Dumper;

use Forge::Model::R::ToPay::Contractor;


my $c = Forge::Model::R::ToPay::Contractor::Manager->get_contractor;
for my $r (@$c) {
	say Dumper($r->code);
}