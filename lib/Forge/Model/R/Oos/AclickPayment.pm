package Forge::Model::R::Oos::AclickPayment;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'aclick_payment',

    columns => [
        id             => { type => 'bigint', not_null => 1 },
        version        => { type => 'bigint', not_null => 1 },
        amount         => { type => 'numeric', not_null => 1, precision => 19, scale => 2 },
        date_created   => { type => 'timestamp' },
        last_updated   => { type => 'timestamp' },
        oos_payment_id => { type => 'bigint', not_null => 1 },
        state          => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('aclick_payment');
1;
