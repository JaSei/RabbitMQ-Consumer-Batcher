use strict;
use warnings;

use Test::More tests => 3;
use Mock::Quick;

use_ok('RabbitMQ::Consumer::Batcher');

my $batch_size = 2;

my $batcher = new_ok(
    'RabbitMQ::Consumer::Batcher',
    [
        batch_size        => $batch_size,
        on_batch_complete => sub {
            my ($batcher, $batch) = @_;

            is(scalar @$batch, $batch_size, 'count of items in batch');
        },
        on_add_catch      => sub {
            my ($batcher, $msg, $exception) = @_;

            fail($exception);
        },
        on_batch_complete_catch => sub {
            my ($batcher, $batch, $exception) = @_;

            fail($exception);
        },
    ]
);

my $consume_code = $batcher->consume_code();

my $consumer_mock = qstrict(
    ack                  => 1,
    reject               => 1,
    reject_and_republish => 1,

);

for my $i (1 .. $batch_size) {
    my $body_mock = qstrict(
        payload => $i,
    );
    $consume_code->($consumer_mock, {body => $body_mock});
}
