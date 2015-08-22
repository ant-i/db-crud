package Model::R::ToPay::ExternalApiEnvironment;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'external_api_environment',

    columns => [
        id              => { type => 'integer', not_null => 1, sequence => 'gate_sequence' },
        name            => { type => 'varchar', default => 'production', length => 32, not_null => 1 },
        external_api_id => { type => 'integer', not_null => 1, remarks => 'A reference to external system API' },
        url             => { type => 'varchar', length => 256, not_null => 1, remarks => 'An URL to environment' },
        key             => { type => 'varchar', length => 512, remarks => 'Environmental key' },
        as_default      => { type => 'boolean', default => 'true', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'name', 'external_api_id' ],

    foreign_keys => [
        external_api => {
            class       => 'Model::R::ToPay::ExternalApi',
            key_columns => { external_api_id => 'id' },
        },
    ],

    relationships => [
        contractors => {
            map_class => 'Model::R::ToPay::ContractorApiAccess',
            map_from  => 'external_api_environment',
            map_to    => 'contractor',
            type      => 'many to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('external_api_environment');
1;
