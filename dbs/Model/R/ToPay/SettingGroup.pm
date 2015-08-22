package Model::R::ToPay::SettingGroup;

use strict;

use base qw(Model::R::ToPay);

__PACKAGE__->meta->setup(
    table   => 'setting_group',

    columns => [
        id          => { type => 'integer', not_null => 1, sequence => 'gate_sequence' },
        name        => { type => 'varchar', length => 128, not_null => 1, remarks => 'A group name' },
        description => { type => 'varchar', length => 512 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        setting => {
            class      => 'Model::R::ToPay::Setting',
            column_map => { id => 'group_id' },
            type       => 'one to many',
        },
    ],
);

__PACKAGE__->meta->make_manager_class('setting_group');
1;
