package Forge::Model::R::Oos::UserRole;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'user_roles',

    columns => [
        role_id => { type => 'bigint', not_null => 1 },
        user_id => { type => 'bigint', not_null => 1 },
    ],

    primary_key_columns => [ 'role_id', 'user_id' ],

    foreign_keys => [
        role => {
            class       => 'Forge::Model::R::Oos::Role',
            key_columns => { role_id => 'id' },
        },

        user => {
            class       => 'Forge::Model::R::Oos::User',
            key_columns => { user_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('user_roles');
1;
