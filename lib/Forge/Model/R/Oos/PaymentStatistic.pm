package Forge::Model::R::Oos::PaymentStatistic;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'payment_statistic',

    columns => [
        id                => { type => 'bigint', not_null => 1 },
        version           => { type => 'bigint', not_null => 1 },
        date              => { type => 'timestamp', not_null => 1 },
        dividend          => { type => 'bigint', not_null => 1 },
        divisor           => { type => 'bigint', not_null => 1 },
        market_place_id   => { type => 'bigint', not_null => 1 },
        name              => { type => 'varchar', length => 255, not_null => 1 },
        payment_method_id => { type => 'bigint', not_null => 1 },
        ratio             => { type => 'numeric', not_null => 1, precision => 19, scale => 2 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        market_place => {
            class       => 'Forge::Model::R::Oos::MarketPlace',
            key_columns => { market_place_id => 'id' },
        },

        payment_method => {
            class       => 'Forge::Model::R::Oos::PaymentMethod',
            key_columns => { payment_method_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('payment_statistic');
1;
