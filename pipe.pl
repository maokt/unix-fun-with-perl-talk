#!/usr/bin/perl
use 5.14.0;

sub pairup (&&);

pairup sub {
    $|=1;
    say "ping" while 1;
    return 0;
}
=> sub {
    my $line = <>;
    chomp $line;
    say qq{right received "$line"};
    return 0;
};

sub pairup (&&) {
    my ($left, $right) = @_;

    my ($in,$out);
    pipe $in, $out;

    my $left_pid = fork();
    if (not defined $left_pid) { die "failed to fork left: $!\n"; }
    if ($left_pid == 0) {
        close $in; # not needed on the left
        open STDOUT, '>&', $out or die "left failed to redirect stdout to pipe: $!\n";
        $SIG{PIPE} = sub { warn "left got SIGPIPE; exiting\n"; exit 99; };
        exit $left->();
    }

    my $right_pid = fork();
    if (not defined $left_pid) { die "failed to fork right: $!\n"; }
    if ($right_pid == 0) {
        close $out; # not needed on the right
        open STDIN, '<&', $in or die "right failed to redirect stdin from pipe: $!\n";
        exit $right->();
    }

    close $in;
    close $out;

    waitpid $left_pid, 0;
    say "left ", explain_exit($?);
    waitpid $right_pid, 0;
    say "right ", explain_exit($?);
}

sub explain_exit {
    my ($code) = @_;
    my $sig = $code & 0x7f;
    my $erc = $code >> 8;
    return "killed by $sig" if $sig;
    return "error $erc" if $erc;
    return "ok";
}

