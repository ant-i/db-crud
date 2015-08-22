package Forge::Model::R::Oos::Client;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'client',

    columns => [
        id                  => { type => 'bigint', not_null => 1 },
        version             => { type => 'bigint', not_null => 1 },
        user_id             => { type => 'bigint' },
        class               => { type => 'varchar', length => 255, not_null => 1 },
        bank_account        => { type => 'varchar', length => 255 },
        email               => { type => 'varchar', length => 255 },
        external_id         => { type => 'varchar', length => 255 },
        inn                 => { type => 'varchar', length => 255 },
        market_place_id     => { type => 'bigint' },
        merchant_limit_id   => { type => 'bigint' },
        name                => { type => 'varchar', length => 255 },
        phone               => { type => 'varchar', length => 255 },
        secret_key          => { type => 'varchar', length => 255 },
        service_description => { type => 'varchar', length => 255 },
        tariff_plan_id      => { type => 'bigint' },
        comment             => { type => 'varchar', length => 255 },
        ek_recipient_id     => { type => 'varchar', length => 255 },
        type                => { type => 'varchar', length => 255 },
        manager_id          => { type => 'bigint' },
        skype_name          => { type => 'varchar', length => 255 },
        code                => { type => 'varchar', length => 255 },
        date_created        => { type => 'timestamp' },
        last_updated        => { type => 'timestamp' },
        note                => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'user_id' ],

    foreign_keys => [
        manager => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { manager_id => 'id' },
        },

        market_place_obj => {
            class       => 'Forge::Model::R::Oos::MarketPlace',
            key_columns => { market_place_id => 'id' },
        },

        merchant_limit => {
            class       => 'Forge::Model::R::Oos::MerchantLimit',
            key_columns => { merchant_limit_id => 'id' },
        },

        tariff_plan => {
            class       => 'Forge::Model::R::Oos::TariffPlan',
            key_columns => { tariff_plan_id => 'id' },
        },

        user => {
            class       => 'Forge::Model::R::Oos::User',
            key_columns => { user_id => 'id' },
            rel_type    => 'one to one',
        },
    ],

    relationships => [
        client => {
            class      => 'Forge::Model::R::Oos::Client',
            column_map => { id => 'manager_id' },
            type       => 'one to many',
        },

        conversion => {
            class      => 'Forge::Model::R::Oos::Conversion',
            column_map => { id => 'merchant_id' },
            type       => 'one to many',
        },

        conversion_action => {
            class      => 'Forge::Model::R::Oos::ConversionAction',
            column_map => { id => 'merchant_id' },
            type       => 'one to many',
        },

        custom_report => {
            class      => 'Forge::Model::R::Oos::CustomReport',
            column_map => { id => 'merchant_id' },
            type       => 'one to many',
        },

        market_place => {
            class      => 'Forge::Model::R::Oos::MarketPlace',
            column_map => { id => 'merchant_id' },
            type       => 'one to many',
        },

        merchant_account => {
            class      => 'Forge::Model::R::Oos::MerchantAccount',
            column_map => { id => 'merchant_id' },
            type       => 'one to many',
        },

        merchant_contact => {
            class      => 'Forge::Model::R::Oos::MerchantContact',
            column_map => { id => 'merchant_id' },
            type       => 'one to many',
        },

        merchant_parameter => {
            class      => 'Forge::Model::R::Oos::MerchantParameter',
            column_map => { id => 'merchant_id' },
            type       => 'one to many',
        },

        message_to_support => {
            class      => 'Forge::Model::R::Oos::MessageToSupport',
            column_map => { id => 'sender_id' },
            type       => 'one to many',
        },

        payment => {
            class      => 'Forge::Model::R::Oos::Payment',
            column_map => { id => 'merchant_id' },
            type       => 'one to many',
        },

        sms => {
            class      => 'Forge::Model::R::Oos::Sm',
            column_map => { id => 'client_id' },
            type       => 'one to many',
        },

        users => {
            class      => 'Forge::Model::R::Oos::User',
            column_map => { id => 'client_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('client');
1;
