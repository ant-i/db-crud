package Model::R::ToPay::OutHttpResponse;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'out_http_response',

    columns => [
        id             => { type => 'scalar', default => 'uuid_generate_v4()', length => 16, not_null => 1 },
        date_created   => { type => 'timestamp', default => 'now()', not_null => 1 },
        out_request_id => { type => 'scalar', length => 16 },
        http_state     => { type => 'integer', default => '0' },
        payload        => { type => 'varchar', length => 4096 },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        out_request => {
            class       => 'Model::R::ToPay::OutHttpRequest',
            key_columns => { out_request_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('out_http_response');
1;
