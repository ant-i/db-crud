package Forge::Model::R::Oos::Aggregator;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'aggregator',

    columns => [
        id            => { type => 'bigint', not_null => 1 },
        version       => { type => 'bigint', not_null => 1 },
        code          => { type => 'varchar', length => 255, not_null => 1 },
        name          => { type => 'varchar', length => 255, not_null => 1 },
        secret_key    => { type => 'varchar', length => 255, not_null => 1 },
        contact_mails => { type => 'varchar', length => 255 },
        description   => { type => 'varchar', length => 255 },
        note          => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        market_place => {
            class      => 'Forge::Model::R::Oos::MarketPlace',
            column_map => { id => 'aggregator_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('aggregator');
1;
