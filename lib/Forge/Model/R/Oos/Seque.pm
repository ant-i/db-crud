package Forge::Model::R::Oos::Seque;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'seque',

    columns => [
        id      => { type => 'bigint', not_null => 1 },
        version => { type => 'bigint', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('seque');
1;
