package Forge::Model::R::Oos::MerchantContact;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'merchant_contact',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        contact      => { type => 'varchar', length => 255, not_null => 1 },
        name         => { type => 'varchar', length => 255, not_null => 1 },
        contacts_idx => { type => 'integer' },
        merchant_id  => { type => 'bigint' },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        merchant => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { merchant_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('merchant_contact');
1;
