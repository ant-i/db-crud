package Forge::Model::R::Oos::CustomReport;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'custom_report',

    columns => [
        id                  => { type => 'bigint', not_null => 1 },
        version             => { type => 'bigint', not_null => 1 },
        area                => { type => 'varchar', length => 255, not_null => 1 },
        conditions          => { type => 'varchar', length => 4096, not_null => 1 },
        date_created        => { type => 'timestamp' },
        last_updated        => { type => 'timestamp' },
        merchant_id         => { type => 'bigint', not_null => 1 },
        title               => { type => 'varchar', length => 255, not_null => 1 },
        auto_send           => { type => 'boolean' },
        out_format          => { type => 'varchar', length => 255 },
        target_email        => { type => 'varchar', length => 255 },
        time_period         => { type => 'varchar', length => 255 },
        use_as_quick_search => { type => 'boolean' },
        use_as_report       => { type => 'boolean' },
        column_set          => { type => 'varchar', length => 255 },
        columns_set         => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        merchant => {
            class       => 'Forge::Model::R::Oos::Client',
            key_columns => { merchant_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('custom_report');
1;
