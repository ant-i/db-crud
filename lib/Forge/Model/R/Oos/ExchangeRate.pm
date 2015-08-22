package Forge::Model::R::Oos::ExchangeRate;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'exchange_rate',

    columns => [
        id                 => { type => 'bigint', not_null => 1 },
        version            => { type => 'bigint', not_null => 1 },
        buy_value          => { type => 'numeric', not_null => 1, precision => 19, scale => 2 },
        central_bank_value => { type => 'numeric', precision => 19, scale => 2 },
        currency_name      => { type => 'varchar', length => 255, not_null => 1 },
        currency_type      => { type => 'varchar', length => 255, not_null => 1 },
        rate_date          => { type => 'timestamp', not_null => 1 },
        sell_value         => { type => 'numeric', not_null => 1, precision => 19, scale => 2 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('exchange_rate');
1;
