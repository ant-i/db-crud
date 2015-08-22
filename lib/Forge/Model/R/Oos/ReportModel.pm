package Forge::Model::R::Oos::ReportModel;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'report_model',

    columns => [
        id             => { type => 'bigint', not_null => 1 },
        version        => { type => 'bigint', not_null => 1 },
        addressees     => { type => 'varchar', length => 2000 },
        cron           => { type => 'varchar', length => 128 },
        name           => { type => 'varchar', length => 512, not_null => 1 },
        params         => { type => 'varchar', length => 6000, not_null => 1 },
        report_id      => { type => 'bigint', not_null => 1 },
        result_handler => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        report => {
            class       => 'Forge::Model::R::Oos::Report',
            key_columns => { report_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('report_model');
1;
