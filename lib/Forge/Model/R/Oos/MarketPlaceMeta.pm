package Forge::Model::R::Oos::MarketPlaceMeta;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'market_place_meta',

    columns => [
        id              => { type => 'bigint', not_null => 1 },
        version         => { type => 'bigint', not_null => 1 },
        alias           => { type => 'varchar', length => 255, remarks => 'ÐÐ´ÐµÐ½ÑÐ¸ÑÐ¸ÐºÐ°ÑÐ¾Ñ Ð¼Ð°Ð³Ð°Ð·Ð½Ð¸Ð½Ð° Ð½Ð° ÑÑÐ¾ÑÐ¾Ð½Ðµ Ð¿Ð»Ð°ÑÐµÐ¶Ð½Ð¾Ð³Ð¾ Ð¼ÐµÑÐ¾Ð´Ð°' },
        market_place_id => { type => 'bigint', not_null => 1, remarks => 'Ð¡ÑÑÐ»ÐºÐ° Ð½Ð° Ð¼Ð°Ð³Ð°Ð·Ð¸Ð½' },
        method_id       => { type => 'bigint', not_null => 1, remarks => 'Ð¡ÑÑÐ»ÐºÐ° Ð½Ð° Ð¿Ð»Ð°ÑÐµÐ¶Ð½ÑÐ¹ Ð¼ÐµÑÐ¾Ð´' },
        extra_data      => { type => 'varchar', length => 255, remarks => 'ÐÐ¾Ð¿Ð¾Ð»Ð½Ð¸ÐµÐ»ÑÐ½ÑÐµ Ð¿Ð°ÑÐ°Ð¼ÐµÑÑÑ ÐºÐ¾ÑÐ¾ÑÑÐµ Ð¿Ð¾ÑÑÐµÐ±ÑÐµÑÑÑ ÑÑÐ°Ð½Ð¸ÑÑ' },
        note            => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        market_place => {
            class       => 'Forge::Model::R::Oos::MarketPlace',
            key_columns => { market_place_id => 'id' },
        },

        method => {
            class       => 'Forge::Model::R::Oos::PaymentMethod',
            key_columns => { method_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('market_place_meta');
1;
