package Forge::Model::R::Oos::Fraud;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'fraud',

    columns => [
        id             => { type => 'bigint', not_null => 1 },
        version        => { type => 'bigint', not_null => 1 },
        date_created   => { type => 'timestamp' },
        description    => { type => 'varchar', length => 50000 },
        fraud_notified => { type => 'boolean' },
        last_updated   => { type => 'timestamp' },
        payment_id     => { type => 'bigint', not_null => 1 },
        score          => { type => 'numeric', not_null => 1, precision => 5, scale => 2 },
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

__PACKAGE__->meta->make_manager_class('fraud');
1;
