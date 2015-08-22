package Forge::Model::R::Oos::Setting;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'settings',

    columns => [
        id          => { type => 'bigint', not_null => 1 },
        version     => { type => 'bigint', not_null => 1 },
        code        => { type => 'varchar', length => 128, not_null => 1 },
        description => { type => 'varchar', length => 250 },
        tag         => { type => 'varchar', length => 200 },
        value       => { type => 'varchar', length => 4000 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('settings');
1;
