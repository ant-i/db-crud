package Forge::Model::R::Oos::MerchantManager;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'merchant_manager',

    columns => [
        id         => { type => 'bigint', not_null => 1 },
        version    => { type => 'bigint', not_null => 1 },
        email      => { type => 'varchar', length => 255, not_null => 1 },
        fio        => { type => 'varchar', length => 255, not_null => 1 },
        phone      => { type => 'varchar', length => 255, not_null => 1 },
        skype_name => { type => 'varchar', length => 255, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
);

__PACKAGE__->meta->make_manager_class('merchant_manager');
1;
