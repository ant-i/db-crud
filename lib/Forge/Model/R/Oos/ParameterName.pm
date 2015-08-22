package Forge::Model::R::Oos::ParameterName;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'parameter_name',

    columns => [
        id        => { type => 'bigint', not_null => 1 },
        version   => { type => 'bigint', not_null => 1 },
        code      => { type => 'varchar', length => 255, not_null => 1 },
        method_id => { type => 'bigint' },
        name      => { type => 'varchar', length => 1024 },
        tag       => { type => 'varchar', length => 512 },
        visible   => { type => 'boolean', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        method => {
            class       => 'Forge::Model::R::Oos::PaymentMethod',
            key_columns => { method_id => 'id' },
        },
    ],

    relationships => [
        payment_method_param_value => {
            class      => 'Forge::Model::R::Oos::PaymentMethodParamValue',
            column_map => { id => 'parameter_name_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('parameter_name');
1;
