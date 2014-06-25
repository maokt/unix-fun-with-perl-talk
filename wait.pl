#!/usr/bin/perl
use 5.14.0;

say "start $$";
my $pid = fork();
if (not defined $pid) {
    die "failed to fork: $!\n";
}
elsif ($pid == 0) { # child
    say "child $$ done";
}
else { # parent
    say "parent $$ done; waiting for $pid";
    wait;
}
