package Forge::Model::R::Oos::MarketPlaceSetting;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'market_place_setting',

    columns => [
        id              => { type => 'bigint', not_null => 1 },
        version         => { type => 'bigint', not_null => 1 },
        active          => { type => 'boolean', not_null => 1 },
        code            => { type => 'varchar', length => 255, not_null => 1 },
        description     => { type => 'varchar', length => 4000 },
        market_place_id => { type => 'bigint', not_null => 1 },
        value           => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        market_place => {
            class       => 'Forge::Model::R::Oos::MarketPlace',
            key_columns => { market_place_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('market_place_setting');
1;
