package Forge::Model::R::Oos::TemplateOverride;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'template_override',

    columns => [
        id              => { type => 'bigint', not_null => 1 },
        version         => { type => 'bigint', not_null => 1 },
        code            => { type => 'varchar', length => 255, not_null => 1 },
        date_created    => { type => 'timestamp', not_null => 1 },
        market_place_id => { type => 'bigint', not_null => 1 },
        number          => { type => 'integer', not_null => 1 },
        type            => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        market_place => {
            class       => 'Forge::Model::R::Oos::MarketPlace',
            key_columns => { market_place_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('template_override');
1;
