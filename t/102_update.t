use t::Utils;
use Mock::Basic;
use Test::More;

Mock::Basic->setup_test_db;
Mock::Basic->insert('mock_basic',{
    id   => 1,
    name => 'perl',
});

subtest 'update mock_basic data' => sub {
    ok +Mock::Basic->update('mock_basic',{name => 'python'},{id => 1});
    my $row = Mock::Basic->single('mock_basic',{id => 1});

    isa_ok $row, 'DBIx::Skinny::Row';
    is $row->name, 'python';
    done_testing;
};

subtest 'row object update' => sub {
    my $row = Mock::Basic->single('mock_basic',{id => 1});
    is $row->name, 'python';

    ok $row->update({name => 'perl'});
    is $row->name, 'perl';
    my $new_row = Mock::Basic->single('mock_basic',{id => 1});
    is $new_row->name, 'perl';
    done_testing;
};

subtest 'row data set and update' => sub {
    my $row = Mock::Basic->single('mock_basic',{id => 1});
    is $row->name, 'perl';

    $row->set({name => 'ruby'});

    is $row->name, 'ruby';

    my $row2 = Mock::Basic->single('mock_basic',{id => 1});
    is $row2->name, 'perl';

    ok $row->update;
    my $new_row = Mock::Basic->single('mock_basic',{id => 1});
    is $new_row->name, 'ruby';
    done_testing;
};

subtest 'scalarref update' => sub {
    my $row = Mock::Basic->single('mock_basic',{id => 1});
    is $row->name, 'ruby';

    ok $row->update({name => '1'});
    my $new_row = Mock::Basic->single('mock_basic',{id => 1});
    is $new_row->name, '1';

    $new_row->update({name => \'name + 1'});

    is +Mock::Basic->single('mock_basic',{id => 1})->name, 2;
    done_testing;
};

subtest 'update row count' => sub {
    Mock::Basic->insert('mock_basic',{
        id   => 2,
        name => 'c++',
    });

    my $cnt = Mock::Basic->update('mock_basic',{name => 'java'});
    is $cnt, 2;
    done_testing;
};


subtest 'update rows using IN operator' => sub {

    is +Mock::Basic->count('mock_basic', 'id'), 2;

    my $update_count = Mock::Basic->update('mock_basic',{name => 'oCaml'}, {id => [1, 2]});
    is $update_count, 2;
    done_testing;
};

done_testing;

