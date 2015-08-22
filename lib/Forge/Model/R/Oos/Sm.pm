package Forge::Model::R::Oos::Sm;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'sms',

    columns => [
        id               => { type => 'bigint', not_null => 1 },
        version          => { type => 'bigint', not_null => 1 },
        client_id        => { type => 'bigint' },
        date_created     => { type => 'timestamp', not_null => 1 },
        error_state      => { type => 'varchar', length => 255 },
        ext_id           => { type => 'varchar', length => 255 },
        message          => { type => 'varchar', length => 4000, not_null => 1 },
        phone            => { type => 'varchar', length => 255, not_null => 1 },
        real_sequence_id => { type => 'varchar', length => 255 },
        sended           => { type => 'boolean', not_null => 1 },
        sender_name      => { type => 'varchar', length => 20 },
        state            => { type => 'varchar', length => 255 },
        subject          => { type => 'varchar', length => 255 },
        type             => { type => 'varchar', length => 255, not_null => 1 },
        user_id          => { type => 'bigint' },
        note             => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        client => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { client_id => 'id' },
        },

        user => {
            class       => 'Forge::Model::R::Oos::User',
            key_columns => { user_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('sms');
1;
