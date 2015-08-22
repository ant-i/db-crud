package Model::R::ToPay::ExternalApiFunction;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'external_api_function',

    columns => [
        id              => { type => 'integer', not_null => 1, sequence => 'gate_sequence' },
        date_created    => { type => 'timestamp', default => 'now()' },
        external_api_id => { type => 'integer', not_null => 1, remarks => 'An API service this function is belongs to' },
        name            => { type => 'varchar', length => 64, not_null => 1, remarks => 'Function name' },
        description     => { type => 'varchar', length => 512, remarks => 'A function description' },
        active          => { type => 'boolean', default => 'true', remarks => 'A global flag for allowing calls to this function on system-wide level' },
        async           => { type => 'boolean', default => 'false', not_null => 1, remarks => 'If given function is asynchronious' },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        external_api => {
            class       => 'Model::R::ToPay::ExternalApi',
            key_columns => { external_api_id => 'id' },
        },
    ],

    relationships => [
        contractor_api_accesses => {
            map_class => 'Model::R::ToPay::ContractorApiFunctionAccess',
            map_from  => 'external_api_function',
            map_to    => 'contractor_api_access',
            type      => 'many to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('external_api_function');
1;
