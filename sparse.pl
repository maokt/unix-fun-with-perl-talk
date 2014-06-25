#!/usr/bin/perl
use 5.14.0;
use File::stat;
use File::Temp "tempfile";

sub show_size {
    my ($f) = @_;
    my $st = stat $f or die;
    say "File size ", $st->size, " occupies ", $st->blocks*512;
}

my $fh = tempfile();
select $fh; $| = 1; select STDOUT; # autoflush

# empty file
show_size($fh);

# add 12 bytes
print $fh "Hello World\n";
show_size($fh);

# add another 4085 bytes
print $fh "."x4085;
show_size($fh);

# move 1 TB into the file and add 8 bytes there
seek $fh, 1e12, 0;
print $fh "Goodbye\n";
show_size($fh);
