package Forge::Model::R::Oos::PaymentParam;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'payment_param',

    columns => [
        id         => { type => 'bigint', not_null => 1 },
        version    => { type => 'bigint', not_null => 1 },
        key        => { type => 'varchar', length => 255, not_null => 1 },
        payment_id => { type => 'bigint', not_null => 1 },
        title      => { type => 'varchar', length => 255 },
        value      => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'key', 'payment_id' ],

    foreign_keys => [
        payment => {
            class       => 'Forge::Model::R::Oos::Payment',
            key_columns => { payment_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('payment_param');
1;
