package Forge::Model::R::Oos::UserChannel;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'user_channel',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        active       => { type => 'boolean', not_null => 1 },
        confirmation => { type => 'boolean', not_null => 1 },
        destination  => { type => 'varchar', length => 255, not_null => 1 },
        method       => { type => 'varchar', length => 255, not_null => 1 },
        notification => { type => 'boolean', not_null => 1 },
        user_id      => { type => 'bigint', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        user => {
            class       => 'Forge::Model::R::Oos::User',
            key_columns => { user_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('user_channel');
1;
