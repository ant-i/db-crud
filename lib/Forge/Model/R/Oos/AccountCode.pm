package Forge::Model::R::Oos::AccountCode;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'account_code',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        code         => { type => 'varchar', length => 32, not_null => 1 },
        date_created => { type => 'timestamp' },
        last_updated => { type => 'timestamp' },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'code' ],
);

__PACKAGE__->meta->make_manager_class('account_code');
1;
