#!/usr/bin/perl
use 5.14.0;
$SIG{INT} = sub {
    state $n = 0;
    if (++$n > 3) {
        say "Well, if you insist...";
        exit 99;
    }
    say "Ouch! That hurt.";
};

while(1) {
    say "Working...";
    sleep 1;
}
