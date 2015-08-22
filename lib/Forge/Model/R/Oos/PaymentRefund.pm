package Forge::Model::R::Oos::PaymentRefund;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'payment_refund',

    columns => [
        id                => { type => 'bigint', not_null => 1 },
        version           => { type => 'bigint', not_null => 1 },
        date_closed       => { type => 'timestamp' },
        date_created      => { type => 'timestamp', not_null => 1 },
        ek_transaction_id => { type => 'varchar', length => 255, not_null => 1 },
        ext_id            => { type => 'varchar', length => 255 },
        payment_id        => { type => 'bigint', not_null => 1 },
        state             => { type => 'varchar', length => 32, not_null => 1 },
        state_date        => { type => 'timestamp' },
        amount            => { type => 'numeric', not_null => 1, precision => 19, scale => 2 },
        sub_state         => { type => 'varchar', length => 32 },
        note              => { type => 'varchar', length => 255 },
        ek_point_id       => { type => 'integer' },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        payment => {
            class       => 'Forge::Model::R::Oos::Payment',
            key_columns => { payment_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('payment_refund');
1;
