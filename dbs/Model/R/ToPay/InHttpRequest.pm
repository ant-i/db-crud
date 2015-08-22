package Model::R::ToPay::InHttpRequest;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'in_http_request',

    columns => [
        id            => { type => 'scalar', default => 'uuid_generate_v4()', length => 16, not_null => 1 },
        date_created  => { type => 'timestamp', default => 'now()', not_null => 1 },
        remote_addr   => { type => 'varchar', length => 128, not_null => 1 },
        uri           => { type => 'varchar', length => 256, not_null => 1, remarks => 'Requested URI' },
        method        => { type => 'varchar', length => 8, remarks => 'A HTTP request method' },
        payload       => { type => 'varchar', default => 'N/A', length => 4096, remarks => 'Request payload' },
        contractor_id => { type => 'integer', remarks => 'Contractor which made this request if any (can be null, surprisinglyl)' },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        contractor => {
            class       => 'Model::R::ToPay::Contractor',
            key_columns => { contractor_id => 'id' },
        },
    ],

    relationships => [
        in_http_response => {
            class      => 'Model::R::ToPay::InHttpResponse',
            column_map => { id => 'in_request_id' },
            type       => 'one to many',
        },

        out_http_request => {
            class      => 'Model::R::ToPay::OutHttpRequest',
            column_map => { id => 'result_of' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('in_http_request');
1;
