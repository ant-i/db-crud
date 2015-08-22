package Forge::Model::R::Oos::Requestmap;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'requestmap',

    columns => [
        id               => { type => 'bigint', not_null => 1 },
        version          => { type => 'bigint', not_null => 1 },
        config_attribute => { type => 'varchar', length => 255, not_null => 1 },
        url              => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'url' ],
);

__PACKAGE__->meta->make_manager_class('requestmap');
1;
