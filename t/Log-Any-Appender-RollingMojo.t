
use lib '../lib';

use Log::Any qw[$log];
use Log::Any::Adapter;

no warnings 'redefine';

Log::Any::Adapter->set('RollingMojo',
	path => "./log",
	category => 'debug'
);

$log->info("Argh!", context => "foo");
# $log->warning([ "Argh!", context => "foo" ]);
# $log->debug([ "Argh!", context => "foo" ]);
# $log->error([ "Argh!", context => "foo" ]);