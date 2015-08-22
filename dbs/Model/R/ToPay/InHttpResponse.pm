package Model::R::ToPay::InHttpResponse;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'in_http_response',

    columns => [
        id            => { type => 'scalar', default => 'uuid_generate_v4()', length => 16, not_null => 1 },
        date_created  => { type => 'timestamp', default => 'now()', not_null => 1 },
        in_request_id => { type => 'scalar', length => 16 },
        http_state    => { type => 'integer', default => '0', remarks => 'HTTP state code representation' },
        gate_state    => { type => 'integer', remarks => 'Gate response code returned in body' },
        cause         => { type => 'varchar', length => 255 },
        payload       => { type => 'varchar', length => 4096, remarks => 'Response payload' },
        contractor_id => { type => 'integer' },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        contractor => {
            class       => 'Model::R::ToPay::Contractor',
            key_columns => { contractor_id => 'id' },
        },

        in_request => {
            class       => 'Model::R::ToPay::InHttpRequest',
            key_columns => { in_request_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('in_http_response');
1;
