package Forge::Model::R::Oos::SearchPlacement;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'search_placement',

    columns => [
        id                  => { type => 'bigint', not_null => 1 },
        version             => { type => 'bigint', not_null => 1 },
        enabled             => { type => 'boolean', not_null => 1 },
        fields              => { type => 'varchar', length => 255, not_null => 1 },
        identificator_field => { type => 'varchar', length => 255, not_null => 1 },
        table_name          => { type => 'varchar', length => 255, not_null => 1 },
        target_class        => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('search_placement');
1;
