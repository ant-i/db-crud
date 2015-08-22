#!/usr/bin/env perl

use lib '../lib';
use Assertion qw/true false should must is_scalar is_array is_hash is_code/;

use Test::More;

#
# true
#

ok( true(1, "Oh noes!"), "truth assertion should pass: test 1" );
ok( true(2, "Oh noes!"), "truth assertion should pass: test 2" );
ok( true(10, "Oh noes!"), "truth assertion should pass: test 3" );
ok( true('a', "Oh noes!"), "truth assertion should pass: test 4" );
ok( true(sub {}, "Oh noes!"), "truth assertion should pass: test 5" );
ok( true([1], "Oh noes!"), "truth assertion should pass: test 6" );
ok( true({a => 0}, "Oh noes!"), "truth assertion should pass: test 7" );

CROAKS: {
	ok ( !eval { true(0, "Bang!") }, "truth assertion should fail: test 1" );
	ok ( !eval { true('', "Bang!") }, "truth assertion should fail: test 2" );
	ok ( !eval { true(undef, "Bang!") }, "truth assertion should fail: test 3" );
	ok ( !eval { true(%{[]}, "Bang!") }, "truth assertion should fail: test 4" );
}

#
# false
#

ok( false(0, "False"), "false assertion should pass: test 1" );
ok( false(undef, "False"), "false assertion should pass: test 2" );
ok( false('', "False"), "false assertion should pass: test 3" );
ok( false([], "False"), "false assertion should pass: test 4" );
ok( false({}, "False"), "false assertion should pass: test 5" );

done_testing();