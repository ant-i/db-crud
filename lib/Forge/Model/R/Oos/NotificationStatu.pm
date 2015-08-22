package Forge::Model::R::Oos::NotificationStatu;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'notification_status',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        action       => { type => 'varchar', length => 255, not_null => 1 },
        addresses    => { type => 'varchar', length => 255, not_null => 1 },
        object_class => { type => 'varchar', length => 255, not_null => 1 },
        object_id    => { type => 'bigint', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'action', 'object_class', 'object_id' ],
);

__PACKAGE__->meta->make_manager_class('notification_status');
1;
