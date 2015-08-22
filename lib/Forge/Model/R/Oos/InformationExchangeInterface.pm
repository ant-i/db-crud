package Forge::Model::R::Oos::InformationExchangeInterface;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'information_exchange_interface',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        code         => { type => 'varchar', length => 32, not_null => 1, remarks => 'Ð£Ð½Ð¸ÐºÐ°Ð»ÑÐ½Ð¾Ðµ ÐºÐ¾Ð´Ð¾Ð²Ð¾Ðµ Ð½Ð°Ð¸Ð¼ÐµÐ½Ð¾Ð²Ð°Ð½Ð¸Ðµ Ð¸Ð½ÑÐµÑÑÐµÐ¹ÑÐ°' },
        description  => { type => 'varchar', length => 1024, remarks => 'ÐÐ¿Ð¸ÑÐ°Ð½Ð¸Ðµ (Ð´Ð»Ñ Ð»ÑÐ´ÐµÐ¹)' },
        service_name => { type => 'varchar', length => 255, not_null => 1, remarks => 'ÐÐ¼Ñ ÐºÐ»Ð°ÑÑÐ° (Ð±ÐµÐ· Ð¿Ð°ÐºÐµÑÐ°) ÑÐµÐ°Ð»Ð¸Ð·ÑÑÑÐ¸Ð¹ Ð¿ÑÐ¾ÑÐ¾ÐºÐ¾Ð» ÑÑÐ¾Ð³Ð¾ Ð¸Ð½ÑÐ¾ÑÐ¼Ð°ÑÐ¸Ð¾Ð½Ð½Ð¾Ð³Ð¾ Ð²Ð·Ð°Ð¸Ð¼Ð¾Ð´ÐµÐ¹ÑÑÐ²Ð¸Ñ' },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        market_place => {
            class      => 'Forge::Model::R::Oos::MarketPlace',
            column_map => { id => 'exchange_interface_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('information_exchange_interface');
1;
