requires 'perl', '5.010';
requires 'Moose';
requires 'Try::Tiny';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Mock::Quick';
};

