# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 6currentsymlink.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 9 };
use Log::Dispatch;
use Log::Dispatch::File::Rolling;
ok(1); # If we made it this far, we're ok.

#########################1

my $dispatcher = Log::Dispatch->new;
ok($dispatcher);

#########################2

my $curr_symlink_filename = 'currsym';

my %params = (
    name      => 'file',
    min_level => 'debug',
    filename  => 'logfile',
    current_symlink => $curr_symlink_filename,
);

my $Rolling = Log::Dispatch::File::Rolling->new(%params);
ok($Rolling);

#########################3

$dispatcher->add($Rolling);

ok(1);

#########################4

my $message = 'logtest id ' . int(rand(9999));

$dispatcher->log( level   => 'info', message => $message );

ok(1);

#########################5

$dispatcher = $Rolling = undef;

ok(1);

#########################6

my @logfiles = glob("logfile.2*");

ok(scalar(@logfiles) == 1 or scalar(@logfiles) == 2);

#########################7

my $content = '';

foreach my $file (@logfiles) {
    open F, '<', $file;
    local $/ = undef;
    $content .= <F>;
    close F;
}

ok($content =~ /$message/);

my $content2 = '';

{
    open F, '<', $curr_symlink_filename;
    local $/ = undef;
    $content2 .= <F>;
    close F;
}

ok($content2 =~ /$message/);

foreach my $file (@logfiles) {
    unlink $file;
}

unlink $curr_symlink_filename;

#########################8
