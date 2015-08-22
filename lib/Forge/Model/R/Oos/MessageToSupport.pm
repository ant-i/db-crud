package Forge::Model::R::Oos::MessageToSupport;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'message_to_support',

    columns => [
        id          => { type => 'bigint', not_null => 1 },
        version     => { type => 'bigint', not_null => 1 },
        sender_id   => { type => 'bigint', not_null => 1 },
        subject     => { type => 'varchar', length => 1024, not_null => 1 },
        text        => { type => 'varchar', length => 8192, not_null => 1 },
        text_format => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        sender => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { sender_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('message_to_support');
1;
