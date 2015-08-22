package Forge::Model::R::Oos::Tariff;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'tariff',

    columns => [
        id                => { type => 'bigint', not_null => 1 },
        version           => { type => 'bigint', not_null => 1 },
        active            => { type => 'boolean' },
        bank_tariff       => { type => 'boolean', not_null => 1 },
        max               => { type => 'numeric', not_null => 1, precision => 5, scale => 2 },
        min               => { type => 'numeric', not_null => 1, precision => 5, scale => 2 },
        payment_method_id => { type => 'bigint' },
        percent           => { type => 'numeric', precision => 5, scale => 2 },
        sum               => { type => 'numeric', not_null => 1, precision => 9, scale => 2 },
        tariff_plan_id    => { type => 'bigint' },
        valid_before      => { type => 'timestamp' },
        tariffs_idx       => { type => 'integer' },
        ek_point_id       => { type => 'bigint' },
        note              => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        ek_point => {
            class       => 'Forge::Model::R::Oos::EkPoint',
            key_columns => { ek_point_id => 'id' },
        },

        payment_method => {
            class       => 'Forge::Model::R::Oos::PaymentMethod',
            key_columns => { payment_method_id => 'id' },
        },

        tariff_plan => {
            class       => 'Forge::Model::R::Oos::TariffPlan',
            key_columns => { tariff_plan_id => 'id' },
        },
    ],

    relationships => [
        payment => {
            class      => 'Forge::Model::R::Oos::Payment',
            column_map => { id => 'tariff_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('tariff');
1;
