package Model::R::ToPay::ContractorApiAccess;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'contractor_api_access',

    columns => [
        id                          => { type => 'integer', not_null => 1, sequence => 'gate_sequence' },
        name                        => { type => 'varchar', length => 256, not_null => 1, remarks => 'A name of access table' },
        date_created                => { type => 'timestamp', default => 'now()' },
        valid_from                  => { type => 'timestamp', remarks => 'This access only valid after certain date-time (if specified)' },
        valid_until                 => { type => 'timestamp', remarks => 'This access is valid until certain date-time (if specified)' },
        active                      => { type => 'boolean', default => 'true', remarks => 'An access is granted' },
        contractor_id               => { type => 'integer', not_null => 1, remarks => 'ID of partner to grant access to' },
        external_api_environment_id => { type => 'integer', not_null => 1, remarks => 'An access to extenal API environment' },
        pass_key                    => { type => 'varchar', default => 'md5((random())::text)', length => 256, remarks => 'A token for partner as a symbol that access is granted to this system' },
        allow_ips                   => { type => 'varchar', default => '*', remarks => 'An IP mask from which requests for given access is allowed' },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        contractor => {
            class       => 'Model::R::ToPay::Contractor',
            key_columns => { contractor_id => 'id' },
        },

        external_api_environment => {
            class       => 'Model::R::ToPay::ExternalApiEnvironment',
            key_columns => { external_api_environment_id => 'id' },
        },
    ],

    relationships => [
        external_api_functions => {
            map_class => 'Model::R::ToPay::ContractorApiFunctionAccess',
            map_from  => 'contractor_api_access',
            map_to    => 'external_api_function',
            type      => 'many to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('contractor_api_access');
1;
