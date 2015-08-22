package Forge::Model::R::Oos::PaymentMethodParamValue;

use strict;

use base qw(Forge::Model::R::Oos);

__PACKAGE__->meta->setup(
    table   => 'payment_method_param_value',

    columns => [
        id                => { type => 'bigint', not_null => 1 },
        version           => { type => 'bigint', not_null => 1 },
        parameter_name_id => { type => 'bigint', not_null => 1 },
        payment_id        => { type => 'bigint', not_null => 1 },
        value             => { type => 'varchar', length => 2048 },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        parameter_name => {
            class       => 'Forge::Model::R::Oos::ParameterName',
            key_columns => { parameter_name_id => 'id' },
        },

        payment => {
            class       => 'Forge::Model::R::Oos::Payment',
            key_columns => { payment_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('payment_method_param_value');
1;
