#!/usr/bin/perl
use 5.14.0;

my @dwarves = qw/ doc grumpy happy sleepy bashful sneezy dopey /;

my %kid;

for my $d (@dwarves) {
    say "+ $d";
    my $pid = fork();
    if (not defined $pid) { die "failed to fork $d: $!\n"; }
    if ($pid == 0) { # child
        sleep rand 10;
        say "$d $$ done";
        exit 0;
    }

    # parent
    $kid{$pid} = $d;
}

while (keys %kid > 0) {
    my $pid = wait;
    my $erc = $?;
    if ($pid == -1) {
        die "no more children, but expected some\n";
    }
    my $d = delete $kid{$pid};
    if (!$d) {
        warn "process $pid is not one of my children!?\n";
    }
    else {
        say "- $d $pid: ", explain_exit($erc);
    }
}

sub explain_exit {
    my ($code) = @_;
    my $sig = $code & 0x7f;
    my $erc = $code >> 8;
    return "killed by $sig" if $sig;
    return "error $erc" if $erc;
    return "ok";
}

