package Forge::Model::R::Oos::ConversionAction;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'conversion_action',

    columns => [
        id            => { type => 'bigint', not_null => 1 },
        version       => { type => 'bigint', not_null => 1 },
        action        => { type => 'varchar', length => 255, not_null => 1 },
        creation_date => { type => 'timestamp', not_null => 1 },
        merchant_id   => { type => 'bigint' },
        user_account  => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        merchant => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { merchant_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('conversion_action');
1;
