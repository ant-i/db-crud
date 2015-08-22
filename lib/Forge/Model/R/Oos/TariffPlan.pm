package Forge::Model::R::Oos::TariffPlan;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'tariff_plan',

    columns => [
        id      => { type => 'bigint', not_null => 1 },
        version => { type => 'bigint', not_null => 1 },
        name    => { type => 'varchar', length => 250 },
        note    => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        client => {
            class      => 'Forge::Model::R::Oos::Client',
            column_map => { id => 'tariff_plan_id' },
            type       => 'one to many',
        },

        market_place => {
            class      => 'Forge::Model::R::Oos::MarketPlace',
            column_map => { id => 'tariff_plan_id' },
            type       => 'one to many',
        },

        tariff => {
            class      => 'Forge::Model::R::Oos::Tariff',
            column_map => { id => 'tariff_plan_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('tariff_plan');
1;
