#!/usr/bin/perl
use 5.14.0;
use File::stat;

sub show_symlink {
    my ($f) = @_;

    my $lst = lstat $f or die;
    my $target = readlink($f);
    say "$f size ", $lst->size, " target $target";

    my $st = stat $f; # $f, not $target
    if ($st) {
        say "  -> $target size is ", $st->size;
    }
    else {
        say "  -> $target does not exist";
    }
}

for my $sl (qw/ symlink-1 symlink-2 symlink-3 /) {
    show_symlink($sl);
}

