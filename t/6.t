# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 8 };
use Log::Dispatch;
use Log::File::Rolling;
ok(1); # If we made it this far, we're ok.

#########################1

my $dispatcher = Log::Dispatch->new;
ok($dispatcher);

#########################2

my %params = (
    name      => 'file',
    min_level => 'debug',
    filename  => 'logfile.txt',
);

my $Rolling = Log::File::Rolling->new(%params);
ok($Rolling);

#########################3

$dispatcher->add($Rolling);

ok(1);

#########################4

my $message1 = 'logtest id ' . int(rand(9999));
my $message2 = 'logtest id ' . int(rand(9999));

$dispatcher->log( level   => 'info', message => $message1 );
close $Rolling->{fh}; # disturb internal bookkeeping, must recover from this
$dispatcher->log( level   => 'info', message => $message2 );

ok(1);

#########################5

$dispatcher = $Rolling = undef;

ok(1);

#########################7

my $content = '';

foreach my $file ('logfile.txt') {
    open F, '<', $file;
    local $/ = undef;
    $content .= <F>;
    close F;
    unlink $file;
}

ok($content =~ /$message1/);
ok($content =~ /$message2/);

#########################8
