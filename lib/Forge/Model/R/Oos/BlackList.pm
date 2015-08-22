package Forge::Model::R::Oos::BlackList;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'black_list',

    columns => [
        id         => { type => 'bigint', not_null => 1 },
        version    => { type => 'bigint', not_null => 1 },
        blocked_id => { type => 'bigint', not_null => 1 },
        comment    => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('black_list');
1;
