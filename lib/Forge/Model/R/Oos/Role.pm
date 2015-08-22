package Forge::Model::R::Oos::Role;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'roles',

    columns => [
        id          => { type => 'bigint', not_null => 1 },
        version     => { type => 'bigint', not_null => 1 },
        authority   => { type => 'varchar', length => 255, not_null => 1 },
        description => { type => 'varchar', length => 512 },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'authority' ],

    relationships => [
        users => {
            map_class => 'Forge::Model::R::Oos::UserRole',
            map_from  => 'role',
            map_to    => 'user',
            type      => 'many to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('roles');
1;
