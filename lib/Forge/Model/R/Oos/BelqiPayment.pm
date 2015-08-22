package Forge::Model::R::Oos::BelqiPayment;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'belqi_payment',

    columns => [
        id                       => { type => 'bigint', not_null => 1 },
        version                  => { type => 'bigint', not_null => 1 },
        account                  => { type => 'varchar', length => 1024, not_null => 1 },
        amount                   => { type => 'numeric', not_null => 1, precision => 19, scale => 2 },
        ek_pay_params            => { type => 'varchar', length => 255 },
        ekuuid                   => { type => 'varchar', length => 255 },
        oos_payment_id           => { type => 'varchar', length => 1024, not_null => 1 },
        request_id               => { type => 'varchar', length => 255 },
        service_id               => { type => 'bigint' },
        state                    => { type => 'varchar', length => 4, not_null => 1 },
        transaction_id           => { type => 'varchar', length => 255 },
        date_created             => { type => 'timestamp' },
        last_updated             => { type => 'timestamp' },
        priorbank_payment_method => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('belqi_payment');
1;
