package Forge::Model::R::Oos::OutQueue;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'out_queue',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        abonent      => { type => 'varchar', length => 5, not_null => 1 },
        corr_id      => { type => 'varchar', length => 50 },
        err_text     => { type => 'varchar', length => 250 },
        message      => { type => 'varchar', length => 4000, not_null => 1 },
        message_type => { type => 'varchar', length => 50 },
        msg_id       => { type => 'varchar', length => 50 },
        pop_time     => { type => 'timestamp' },
        push_time    => { type => 'timestamp', not_null => 1 },
        state        => { type => 'varchar', length => 32, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('out_queue');
1;
