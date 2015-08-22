package Model::R::ToPay::ContractorApiFunctionAccess;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'contractor_api_function_access',

    columns => [
        contractor_api_access_id => { type => 'integer', not_null => 1 },
        external_api_function_id => { type => 'integer', not_null => 1 },
        active                   => { type => 'boolean', default => 'true', not_null => 1 },
        date_created             => { type => 'timestamp', default => 'now()', not_null => 1 },
    ],

    primary_key_columns => [ 'contractor_api_access_id', 'external_api_function_id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        contractor_api_access => {
            class       => 'Model::R::ToPay::ContractorApiAccess',
            key_columns => { contractor_api_access_id => 'id' },
        },

        external_api_function => {
            class       => 'Model::R::ToPay::ExternalApiFunction',
            key_columns => { external_api_function_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('contractor_api_function_access');
1;
