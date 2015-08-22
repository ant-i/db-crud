package Forge::Model::R::Oos::PayerInfo;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'payer_info',

    columns => [
        id         => { type => 'bigint', not_null => 1 },
        version    => { type => 'bigint', not_null => 1 },
        ip         => { type => 'varchar', length => 45, not_null => 1, remarks => 'IP (v4, v6) Ð°Ð´ÑÐµÑ' },
        locale     => { type => 'varchar', length => 8, not_null => 1, remarks => 'Ð¯Ð·ÑÐºÐ¾Ð²ÑÐµ Ð½Ð°ÑÑÑÐ¾Ð¹ÐºÐ¸ User-Agent-Ð°' },
        payment_id => { type => 'bigint', not_null => 1 },
        referrer   => { type => 'varchar', length => 5120, remarks => 'HTTP Referer (Ð¾ÑÐºÑÐ´Ð° Ð¿ÑÐ¸ÑÐµÐ»)' },
        user_agent => { type => 'varchar', length => 512, not_null => 1, remarks => 'ÐÐ½ÑÐ¾ÑÐ¼Ð°ÑÐ¸Ñ Ð¾ User-Agent Ð¿Ð»Ð°ÑÐµÐ»ÑÑÐ¸ÐºÐ°' },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'payment_id' ],

    foreign_keys => [
        payment => {
            class       => 'Forge::Model::R::Oos::Payment',
            key_columns => { payment_id => 'id' },
            rel_type    => 'one to one',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('payer_info');
1;
