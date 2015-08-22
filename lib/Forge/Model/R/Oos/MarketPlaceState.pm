package Forge::Model::R::Oos::MarketPlaceState;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'market_place_state',

    columns => [
        id      => { type => 'bigint', not_null => 1 },
        version => { type => 'bigint', not_null => 1 },
        code    => { type => 'varchar', length => 255, not_null => 1 },
        name    => { type => 'varchar', length => 255, not_null => 1 },
        note    => { type => 'varchar', length => 512, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'code' ],

    relationships => [
        market_place => {
            class      => 'Forge::Model::R::Oos::MarketPlace',
            column_map => { id => 'market_place_state_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('market_place_state');
1;
