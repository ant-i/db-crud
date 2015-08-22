package Forge::Model::R::Oos::PaymentHistory;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'payment_history',

    columns => [
        id             => { type => 'bigint', not_null => 1 },
        version        => { type => 'bigint', not_null => 1 },
        action_date    => { type => 'timestamp', not_null => 1 },
        history_action => { type => 'varchar', length => 255, not_null => 1 },
        payment_id     => { type => 'bigint', not_null => 1 },
        comment        => { type => 'varchar', length => 4096 },
        circumstances  => { type => 'varchar', length => 4096 },
        payment_state  => { type => 'varchar', length => 32 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        payment => {
            class       => 'Forge::Model::R::Oos::Payment',
            key_columns => { payment_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('payment_history');
1;
