#!/usr/bin/perl
use 5.14.0;
use File::stat;

my $st = stat $0 or die;
my @stat_fields = qw/
    dev ino mode nlink uid gid rdev
    size atime mtime ctime blksize blocks
/;

my %pp;
$pp{mode} = sub { sprintf "%0o", $_[0] };
$pp{$_} = sub { scalar localtime $_[0] } for qw/ atime ctime mtime /;
$pp{$_} ||= sub {$_[0]} for @stat_fields;

for my $i (@stat_fields) {
    say "$i: ", $pp{$i}->( $st->$i );
}

