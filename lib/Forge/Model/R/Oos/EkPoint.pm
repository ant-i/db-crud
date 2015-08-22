package Forge::Model::R::Oos::EkPoint;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'ek_point',

    columns => [
        id         => { type => 'bigint', not_null => 1 },
        version    => { type => 'bigint', not_null => 1 },
        ekassir_id => { type => 'varchar', length => 255, not_null => 1 },
        key        => { type => 'varchar', length => 4096, not_null => 1 },
        title      => { type => 'varchar', length => 512 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        payment_method => {
            class      => 'Forge::Model::R::Oos::PaymentMethod',
            column_map => { id => 'ek_point_id' },
            type       => 'one to many',
        },

        tariff => {
            class      => 'Forge::Model::R::Oos::Tariff',
            column_map => { id => 'ek_point_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('ek_point');
1;
