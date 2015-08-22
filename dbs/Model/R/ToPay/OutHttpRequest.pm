package Model::R::ToPay::OutHttpRequest;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'out_http_request',

    columns => [
        id              => { type => 'scalar', default => 'uuid_generate_v4()', length => 16, not_null => 1 },
        date_created    => { type => 'timestamp', default => 'now()', not_null => 1 },
        url             => { type => 'varchar', length => 256, not_null => 1, remarks => 'Which URL request is made to' },
        method          => { type => 'varchar', length => 8 },
        payload         => { type => 'varchar', length => 4096 },
        result_of       => { type => 'scalar', length => 16, remarks => 'This HTTP request was made due to in_http_request.' },
        external_api_id => { type => 'integer' },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        external_api => {
            class       => 'Model::R::ToPay::ExternalApi',
            key_columns => { external_api_id => 'id' },
        },

        in_http_request => {
            class       => 'Model::R::ToPay::InHttpRequest',
            key_columns => { result_of => 'id' },
        },
    ],

    relationships => [
        out_http_response => {
            class      => 'Model::R::ToPay::OutHttpResponse',
            column_map => { id => 'out_request_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('out_http_request');
1;
