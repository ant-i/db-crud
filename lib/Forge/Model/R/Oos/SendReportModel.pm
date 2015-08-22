package Forge::Model::R::Oos::SendReportModel;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'send_report_model',

    columns => [
        id                   => { type => 'bigint', not_null => 1 },
        version              => { type => 'bigint', not_null => 1 },
        allow_multi_payments => { type => 'boolean', not_null => 1 },
        check_fail_url       => { type => 'varchar', length => 255 },
        check_ok_url         => { type => 'varchar', length => 255 },
        check_url            => { type => 'varchar', length => 255 },
        market_place_id      => { type => 'bigint' },
        report_format        => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        market_place => {
            class       => 'Forge::Model::R::Oos::MarketPlace',
            key_columns => { market_place_id => 'id' },
        },
    ],

    relationships => [
        market_place_objs => {
            class      => 'Forge::Model::R::Oos::MarketPlace',
            column_map => { id => 'send_report_model_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('send_report_model');
1;
