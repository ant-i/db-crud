package Forge::Model::R::Oos::MerchantAccount;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'merchant_account',

    columns => [
        id              => { type => 'bigint', not_null => 1 },
        version         => { type => 'bigint', not_null => 1 },
        account_type_id => { type => 'bigint', not_null => 1 },
        active          => { type => 'boolean', not_null => 1 },
        date_created    => { type => 'timestamp', not_null => 1 },
        description     => { type => 'varchar', length => 256, not_null => 1 },
        ext_id          => { type => 'varchar', length => 255, not_null => 1 },
        last_updated    => { type => 'timestamp', not_null => 1 },
        merchant_id     => { type => 'bigint', not_null => 1 },
        num             => { type => 'varchar', length => 255, not_null => 1 },
        currency        => { type => 'varchar', length => 255 },
        saldo           => { type => 'numeric', precision => 19, scale => 2 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        account_type => {
            class       => 'Forge::Model::R::Oos::MerchantAccountType',
            key_columns => { account_type_id => 'id' },
        },

        merchant => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { merchant_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('merchant_account');
1;
