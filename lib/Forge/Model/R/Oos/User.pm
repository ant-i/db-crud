package Forge::Model::R::Oos::User;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'users',

    columns => [
        id                   => { type => 'bigint', not_null => 1 },
        version              => { type => 'bigint', not_null => 1 },
        account_expired      => { type => 'boolean', not_null => 1 },
        account_locked       => { type => 'boolean', not_null => 1 },
        date_created         => { type => 'timestamp', not_null => 1 },
        double_password      => { type => 'boolean', not_null => 1 },
        enabled              => { type => 'boolean', not_null => 1 },
        ext_id               => { type => 'varchar', length => 255 },
        ips                  => { type => 'varchar', length => 4000 },
        last_login           => { type => 'timestamp' },
        locale               => { type => 'varchar', length => 255 },
        note                 => { type => 'varchar', length => 160 },
        password             => { type => 'varchar', length => 255, not_null => 1 },
        password_expired     => { type => 'boolean', not_null => 1 },
        phone                => { type => 'varchar', length => 255, not_null => 1 },
        repassword           => { type => 'varchar', length => 255 },
        username             => { type => 'varchar', length => 255, not_null => 1 },
        client_id            => { type => 'bigint' },
        name                 => { type => 'varchar', length => 64 },
        reset_password_token => { type => 'varchar', length => 256 },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'username' ],

    foreign_keys => [
        client => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { client_id => 'id' },
        },
    ],

    relationships => [
        client_obj => {
            class                => 'Forge::Model::R::Oos::Client',
            column_map           => { id => 'user_id' },
            type                 => 'one to one',
            with_column_triggers => '0',
        },

        roles => {
            map_class => 'Forge::Model::R::Oos::UserRole',
            map_from  => 'user',
            map_to    => 'role',
            type      => 'many to many',
        },

        search_query => {
            class      => 'Forge::Model::R::Oos::SearchQuery',
            column_map => { id => 'user_id' },
            type       => 'one to many',
        },

        sms => {
            class      => 'Forge::Model::R::Oos::Sm',
            column_map => { id => 'user_id' },
            type       => 'one to many',
        },

        user_channel => {
            class      => 'Forge::Model::R::Oos::UserChannel',
            column_map => { id => 'user_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('users');
1;
