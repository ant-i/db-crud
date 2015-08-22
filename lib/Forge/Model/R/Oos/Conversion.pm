package Forge::Model::R::Oos::Conversion;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'conversion',

    columns => [
        id                => { type => 'bigint', not_null => 1 },
        version           => { type => 'bigint', not_null => 1 },
        actions_type_what => { type => 'varchar', length => 255, not_null => 1 },
        actions_type_with => { type => 'varchar', length => 255, not_null => 1 },
        description       => { type => 'varchar', length => 255, not_null => 1 },
        merchant_id       => { type => 'bigint' },
        name              => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        merchant => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { merchant_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('conversion');
1;
