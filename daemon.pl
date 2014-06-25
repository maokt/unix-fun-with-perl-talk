#!/usr/bin/perl
use 5.14.0;
use POSIX;

# daemonise
# 1. parent forks and waits for child to exit
# 2. child starts a new session
# 3. child redirects I/O
# 4. child forks but does NOT wait for grandchild
# 5. grandchild is now the daemon

my $pid = fork();
die "fork failed: $!\n" if not defined $pid;
if ($pid > 0) {
    # parent
    my $kid = waitpid $pid, 0;
    exit($kid == $pid ? $? : 71);
}

POSIX::setsid();
open STDIN, '<', "/dev/null" or die "failed to redirect stdin from /dev/null: $!\n";
open STDOUT, '>', "/dev/null" or die "failed to redirect stdout to /dev/null: $!\n";
open STDERR, '>&', STDOUT or die "failed to redirect stderr to /dev/null: $!\n";

my $daemon = fork();
die "fork failed: $!\n" if not defined $daemon;
exit 0 if $daemon > 0;
    
$SIG{$_} = \&handle_sig for qw/ TERM INT HUP QUIT /;

# do something more useful than sleep
sleep 10;

exit 0;
