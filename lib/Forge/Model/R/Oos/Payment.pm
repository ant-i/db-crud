package Forge::Model::R::Oos::Payment;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'payment',

    columns => [
        id                     => { type => 'bigint', not_null => 1 },
        version                => { type => 'bigint', not_null => 1 },
        account                => { type => 'varchar', length => 255 },
        amount                 => { type => 'numeric', not_null => 1, precision => 19, scale => 3 },
        bank_fee               => { type => 'numeric', precision => 19, scale => 3 },
        comment                => { type => 'varchar', length => 255 },
        date_closed            => { type => 'timestamp' },
        date_created           => { type => 'timestamp', not_null => 1 },
        description            => { type => 'varchar', length => 255 },
        ek_transaction_id      => { type => 'varchar', length => 255 },
        ext_id                 => { type => 'varchar', length => 255 },
        ext_state              => { type => 'varchar', length => 255, not_null => 1 },
        fee                    => { type => 'numeric', not_null => 1, precision => 19, scale => 3 },
        gate_id                => { type => 'integer' },
        json_data              => { type => 'varchar', length => 255 },
        last_state_check       => { type => 'timestamp' },
        market_place_id        => { type => 'bigint' },
        merchant_id            => { type => 'bigint', not_null => 1 },
        method_id              => { type => 'bigint' },
        serial_id              => { type => 'integer' },
        state                  => { type => 'varchar', length => 32, not_null => 1 },
        tariff_id              => { type => 'bigint' },
        transaction_id         => { type => 'varchar', length => 255 },
        user_contact           => { type => 'varchar', length => 255 },
        class                  => { type => 'varchar', length => 255, not_null => 1 },
        payment_id             => { type => 'bigint' },
        point_id               => { type => 'varchar', length => 255 },
        user_account           => { type => 'varchar', length => 255 },
        is_exported            => { type => 'boolean', default => 'false' },
        fail_url               => { type => 'varchar', length => 2048 },
        success_url            => { type => 'varchar', length => 2048 },
        is_notified            => { type => 'boolean', default => 'false' },
        state_date             => { type => 'timestamp' },
        customer_rating        => { type => 'integer' },
        ext_state_date         => { type => 'timestamp' },
        service_id             => { type => 'varchar', length => 255 },
        point_address          => { type => 'varchar', length => 255 },
        storage                => { type => 'bytea' },
        customer_email         => { type => 'varchar', length => 512 },
        customer_phone         => { type => 'varchar', length => 32 },
        merchant_comment       => { type => 'varchar', length => 2048 },
        sub_state              => { type => 'varchar', length => 32 },
        last_error_area        => { type => 'varchar', length => 255 },
        last_error_code        => { type => 'varchar', length => 255 },
        last_error_description => { type => 'varchar', length => 255 },
        recurrency_enabled     => { type => 'boolean' },
        recurrency_token       => { type => 'varchar', length => 255 },
        request                => { type => 'varchar', length => 50000 },
        fraud_description      => { type => 'varchar', length => 50000 },
        fraud_notified         => { type => 'boolean' },
        fraud_score            => { type => 'numeric', precision => 5, scale => 2 },
        processing             => { type => 'varchar', length => 7 },
        show_order_id          => { type => 'varchar', length => 255 },
        fetch_parameters       => { type => 'boolean' },
        original_amount        => { type => 'numeric', precision => 19, scale => 3 },
        last_error_sub_code    => { type => 'varchar', length => 255 },
        note                   => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        market_place => {
            class       => 'Forge::Model::R::Oos::MarketPlace',
            key_columns => { market_place_id => 'id' },
        },

        merchant => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { merchant_id => 'id' },
        },

        method => {
            class       => 'Forge::Model::R::Oos::PaymentMethod',
            key_columns => { method_id => 'id' },
        },

        payment => {
            class       => 'Forge::Model::R::Oos::Payment',
            key_columns => { payment_id => 'id' },
        },

        tariff => {
            class       => 'Forge::Model::R::Oos::Tariff',
            key_columns => { tariff_id => 'id' },
        },
    ],

    relationships => [
        fraud => {
            class                => 'Forge::Model::R::Oos::Fraud',
            column_map           => { id => 'payment_id' },
            type                 => 'one to one',
            with_column_triggers => '0',
        },

        payer_info => {
            class                => 'Forge::Model::R::Oos::PayerInfo',
            column_map           => { id => 'payment_id' },
            type                 => 'one to one',
            with_column_triggers => '0',
        },

        payment_history => {
            class      => 'Forge::Model::R::Oos::PaymentHistory',
            column_map => { id => 'payment_id' },
            type       => 'one to many',
        },

        payment_method_param_value => {
            class      => 'Forge::Model::R::Oos::PaymentMethodParamValue',
            column_map => { id => 'payment_id' },
            type       => 'one to many',
        },

        payment_objs => {
            class      => 'Forge::Model::R::Oos::Payment',
            column_map => { id => 'payment_id' },
            type       => 'one to many',
        },

        payment_param => {
            class      => 'Forge::Model::R::Oos::PaymentParam',
            column_map => { id => 'payment_id' },
            type       => 'one to many',
        },

        payment_refund => {
            class      => 'Forge::Model::R::Oos::PaymentRefund',
            column_map => { id => 'payment_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('payment');
1;
