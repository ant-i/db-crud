package Forge::Model::R::Oos::MarketPlace;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'market_place',

    columns => [
        id                         => { type => 'bigint', not_null => 1 },
        version                    => { type => 'bigint', not_null => 1 },
        merchant_id                => { type => 'bigint' },
        name                       => { type => 'varchar', length => 255, not_null => 1 },
        tariff_plan_id             => { type => 'bigint' },
        url                        => { type => 'varchar', length => 255, not_null => 1 },
        state                      => { type => 'varchar', length => 255 },
        fail_url                   => { type => 'varchar', length => 255 },
        ok_url                     => { type => 'varchar', length => 255 },
        send_report_model_id       => { type => 'bigint' },
        ek_service_alias           => { type => 'varchar', length => 255 },
        ek_service_id              => { type => 'varchar', length => 255 },
        code                       => { type => 'varchar', length => 255 },
        logo                       => { type => 'bytea' },
        terminal_type              => { type => 'varchar', length => 64 },
        notification_by_email_on   => { type => 'boolean' },
        notification_emails        => { type => 'varchar', length => 1024 },
        pay_states_of_notification => { type => 'varchar', length => 255 },
        fraud_notification_emails  => { type => 'varchar', length => 1024 },
        fraud_notification_on      => { type => 'boolean' },
        ek_recipient_id            => { type => 'integer' },
        name_english               => { type => 'varchar', length => 255 },
        date_created               => { type => 'timestamp' },
        last_updated               => { type => 'timestamp' },
        service_description        => { type => 'varchar', length => 255 },
        exchange_interface_id      => { type => 'bigint' },
        ek_recipient_id2           => { type => 'integer' },
        check_url                  => { type => 'varchar', length => 1024 },
        market_place_state_id      => { type => 'bigint', not_null => 1 },
        aggregator_id              => { type => 'bigint' },
        note                       => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        aggregator => {
            class       => 'Forge::Model::R::Oos::Aggregator',
            key_columns => { aggregator_id => 'id' },
        },

        exchange_interface => {
            class       => 'Forge::Model::R::Oos::InformationExchangeInterface',
            key_columns => { exchange_interface_id => 'id' },
        },

        market_place_state => {
            class       => 'Forge::Model::R::Oos::MarketPlaceState',
            key_columns => { market_place_state_id => 'id' },
        },

        merchant => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { merchant_id => 'id' },
        },

        send_report_model_obj => {
            class       => 'Forge::Model::R::Oos::SendReportModel',
            key_columns => { send_report_model_id => 'id' },
        },

        tariff_plan => {
            class       => 'Forge::Model::R::Oos::TariffPlan',
            key_columns => { tariff_plan_id => 'id' },
        },
    ],

    relationships => [
        client => {
            class      => 'Forge::Model::R::Oos::Client',
            column_map => { id => 'market_place_id' },
            type       => 'one to many',
        },

        market_place_meta => {
            class      => 'Forge::Model::R::Oos::MarketPlaceMeta',
            column_map => { id => 'market_place_id' },
            type       => 'one to many',
        },

        market_place_setting => {
            class      => 'Forge::Model::R::Oos::MarketPlaceSetting',
            column_map => { id => 'market_place_id' },
            type       => 'one to many',
        },

        payment => {
            class      => 'Forge::Model::R::Oos::Payment',
            column_map => { id => 'market_place_id' },
            type       => 'one to many',
        },

        payment_statistic => {
            class      => 'Forge::Model::R::Oos::PaymentStatistic',
            column_map => { id => 'market_place_id' },
            type       => 'one to many',
        },

        send_report_model => {
            class      => 'Forge::Model::R::Oos::SendReportModel',
            column_map => { id => 'market_place_id' },
            type       => 'one to many',
        },

        template_override => {
            class      => 'Forge::Model::R::Oos::TemplateOverride',
            column_map => { id => 'market_place_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('market_place');
1;
