package Model::R::ToPay::Contractor;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'contractor',

    columns => [
        id               => { type => 'integer', not_null => 1, sequence => 'gate_sequence' },
        name             => { type => 'varchar', length => 256, remarks => 'A real name of partner/contractor' },
        code             => { type => 'varchar', length => 32, not_null => 1, remarks => 'An alphanumeric latin representation of contractor (aside from id)' },
        datetime_created => { type => 'timestamp', default => 'now()', not_null => 1 },
        active           => { type => 'boolean', default => 'true', remarks => 'Is enabled and given access to gate' },
        salt             => { type => 'varchar', length => 128, remarks => 'Some secret key for generating signature' },
        fist_algorithm   => { type => 'varchar', length => 16, remarks => 'A first algorithm name of modifying salt before generating signature' },
        final_algorithm  => { type => 'varchar', length => 16, remarks => 'A final algorithm name to shuffle bytes after making signature presentation' },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'code' ],

    allow_inline_column_values => 1,

    relationships => [
        external_api_environments => {
            map_class => 'Model::R::ToPay::ContractorApiAccess',
            map_from  => 'contractor',
            map_to    => 'external_api_environment',
            type      => 'many to many',
        },

        in_http_request => {
            class      => 'Model::R::ToPay::InHttpRequest',
            column_map => { id => 'contractor_id' },
            type       => 'one to many',
        },

        in_http_response => {
            class      => 'Model::R::ToPay::InHttpResponse',
            column_map => { id => 'contractor_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('contractor');
1;
