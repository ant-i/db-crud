package Forge::Model::R::Oos::MerchantLimit;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'merchant_limit',

    columns => [
        id      => { type => 'bigint', not_null => 1 },
        version => { type => 'bigint', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        client => {
            class      => 'Forge::Model::R::Oos::Client',
            column_map => { id => 'merchant_limit_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('merchant_limit');
1;
