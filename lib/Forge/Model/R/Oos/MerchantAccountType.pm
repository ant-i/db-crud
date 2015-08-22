package Forge::Model::R::Oos::MerchantAccountType;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'merchant_account_type',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        code         => { type => 'varchar', length => 255, not_null => 1 },
        date_created => { type => 'timestamp', not_null => 1 },
        description  => { type => 'varchar', length => 256 },
        ext_id       => { type => 'varchar', length => 255, not_null => 1 },
        last_updated => { type => 'timestamp', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        merchant_account => {
            class      => 'Forge::Model::R::Oos::MerchantAccount',
            column_map => { id => 'account_type_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('merchant_account_type');
1;
