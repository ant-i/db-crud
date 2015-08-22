package Forge::Model::R::Oos::New;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'news',

    columns => [
        id              => { type => 'bigint', not_null => 1 },
        version         => { type => 'bigint', not_null => 1 },
        text            => { type => 'varchar', length => 4096, not_null => 1 },
        title           => { type => 'varchar', length => 255, not_null => 1 },
        date_created    => { type => 'timestamp' },
        last_updated    => { type => 'timestamp' },
        date_modified   => { type => 'timestamp' },
        expired         => { type => 'timestamp' },
        hash            => { type => 'integer' },
        permanent       => { type => 'boolean' },
        prio            => { type => 'integer', not_null => 1 },
        publish_date    => { type => 'timestamp' },
        tags            => { type => 'varchar', length => 255 },
        date_creation   => { type => 'varchar', length => 255 },
        notify_merchant => { type => 'boolean' },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('news');
1;
