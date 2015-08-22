package Forge::Model::R::Oos::MerchantParameter;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'merchant_parameter',

    columns => [
        id          => { type => 'bigint', not_null => 1 },
        version     => { type => 'bigint', not_null => 1 },
        code        => { type => 'varchar', length => 255, not_null => 1 },
        merchant_id => { type => 'bigint', not_null => 1 },
        value       => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        merchant => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { merchant_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('merchant_parameter');
1;
