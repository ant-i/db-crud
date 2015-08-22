package Forge::Model::R::Oos::Report;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'report',

    columns => [
        id           => { type => 'bigint', not_null => 1 },
        version      => { type => 'bigint', not_null => 1 },
        active       => { type => 'boolean', not_null => 1 },
        countable    => { type => 'varchar', length => 255 },
        description  => { type => 'varchar', length => 4000 },
        fields       => { type => 'varchar', length => 512 },
        name         => { type => 'varchar', length => 512, not_null => 1 },
        out_format   => { type => 'varchar', length => 16, not_null => 1 },
        script       => { type => 'varchar', length => 50000, not_null => 1 },
        summable     => { type => 'varchar', length => 255 },
        type         => { type => 'varchar', length => 16, not_null => 1 },
        date_created => { type => 'timestamp' },
        last_updated => { type => 'timestamp' },
        class        => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        report_model => {
            class      => 'Forge::Model::R::Oos::ReportModel',
            column_map => { id => 'report_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('report');
1;
