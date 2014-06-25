#!/usr/bin/perl
use 5.14.0;

say "start $$";
my $pid = fork();
if (not defined $pid) {
    die "failed to fork: $!\n";
}
elsif ($pid == 0) { # child
    say "child $$ done";
    exit 0;
}

# parent
say "parent $$ done; waiting for $pid";
wait;

say "my child finished: ", explain_exit($?);
sub explain_exit {
    my ($code) = @_;
    my $sig = $code & 0x7f;
    my $erc = $code >> 8;
    return "killed by $sig" if $sig;
    return "error $erc" if $erc;
    return "ok";
}

