package Forge::Model::R::Oos::SearchQuery;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'search_query',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        name         => { type => 'varchar', length => 512 },
        params       => { type => 'varchar', length => 4048, not_null => 1 },
        shared       => { type => 'boolean', not_null => 1 },
        shared_with  => { type => 'varchar', length => 255 },
        user_id      => { type => 'bigint', not_null => 1 },
        class        => { type => 'varchar', length => 255, not_null => 1 },
        addressee    => { type => 'varchar', length => 2048 },
        repeat_cron  => { type => 'varchar', length => 255 },
        repeat_times => { type => 'integer' },
        repeatable   => { type => 'boolean' },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        user => {
            class       => 'Forge::Model::R::Oos::User',
            key_columns => { user_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('search_query');
1;
