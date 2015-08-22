package Model::R::ToPay::Setting;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'setting',

    columns => [
        id           => { type => 'integer', not_null => 1, sequence => 'gate_sequence' },
        date_created => { type => 'timestamp', default => 'now()' },
        code         => { type => 'varchar', length => 64, not_null => 1, remarks => 'A setting code name. Must be unique for given group' },
        value        => { type => 'varchar', length => 1024, remarks => 'A setting value' },
        type         => { type => 'varchar', default => 'string', length => 16, remarks => 'Setting value type' },
        group_id     => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        group => {
            class       => 'Model::R::ToPay::SettingGroup',
            key_columns => { group_id => 'id' },
        },
    ],
);

__PACKAGE__->meta->make_manager_class('setting');
1;
