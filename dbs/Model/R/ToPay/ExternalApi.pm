package Model::R::ToPay::ExternalApi;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'external_api',

    columns => [
        id            => { type => 'integer', not_null => 1, sequence => 'gate_sequence' },
        date_created  => { type => 'timestamp', default => 'now()' },
        name          => { type => 'varchar', length => 256 },
        code          => { type => 'varchar', length => 16, not_null => 1, remarks => 'A code representation of external system' },
        description   => { type => 'varchar', default => 'N/A', length => 256 },
        url           => { type => 'varchar', length => 256, not_null => 1, remarks => 'Default URL' },
        format        => { type => 'varchar', length => 16, remarks => 'Communication and message format' },
        actor_package => { type => 'varchar', length => 128, not_null => 1, remarks => 'Integration package/class responsible for communication with given API' },
        api_reference => { type => 'varchar', length => 256, remarks => 'An URL to documentation and API reference' },
        active        => { type => 'boolean', default => 'true' },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    relationships => [
        external_api_environment => {
            class      => 'Model::R::ToPay::ExternalApiEnvironment',
            column_map => { id => 'external_api_id' },
            type       => 'one to many',
        },

        external_api_function => {
            class      => 'Model::R::ToPay::ExternalApiFunction',
            column_map => { id => 'external_api_id' },
            type       => 'one to many',
        },

        out_http_request => {
            class      => 'Model::R::ToPay::OutHttpRequest',
            column_map => { id => 'external_api_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('external_api');
1;
