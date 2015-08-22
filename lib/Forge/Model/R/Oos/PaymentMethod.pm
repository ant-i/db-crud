package Forge::Model::R::Oos::PaymentMethod;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'payment_method',

    columns => [
        id                         => { type => 'bigint', not_null => 1 },
        version                    => { type => 'bigint', not_null => 1 },
        code                       => { type => 'varchar', length => 255, not_null => 1 },
        name                       => { type => 'varchar', length => 255, not_null => 1 },
        url                        => { type => 'varchar', length => 255, not_null => 1 },
        active                     => { type => 'boolean', not_null => 1 },
        refundable                 => { type => 'boolean', not_null => 1 },
        refund_alias               => { type => 'varchar', length => 255 },
        expiration_period          => { type => 'varchar', length => 255 },
        displayable                => { type => 'boolean' },
        gateway_simple_name        => { type => 'varchar', length => 255 },
        market_place_meta_required => { type => 'boolean' },
        description                => { type => 'varchar', length => 255 },
        ek_point_id                => { type => 'bigint' },
        note                       => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        ek_point => {
            class       => 'Forge::Model::R::Oos::EkPoint',
            key_columns => { ek_point_id => 'id' },
        },
    ],

    relationships => [
        market_place_meta => {
            class      => 'Forge::Model::R::Oos::MarketPlaceMeta',
            column_map => { id => 'method_id' },
            type       => 'one to many',
        },

        parameter_name => {
            class      => 'Forge::Model::R::Oos::ParameterName',
            column_map => { id => 'method_id' },
            type       => 'one to many',
        },

        payment => {
            class      => 'Forge::Model::R::Oos::Payment',
            column_map => { id => 'method_id' },
            type       => 'one to many',
        },

        payment_statistic => {
            class      => 'Forge::Model::R::Oos::PaymentStatistic',
            column_map => { id => 'payment_method_id' },
            type       => 'one to many',
        },

        tariff => {
            class      => 'Forge::Model::R::Oos::Tariff',
            column_map => { id => 'payment_method_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('payment_method');
1;
