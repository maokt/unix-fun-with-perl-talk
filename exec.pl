#!/usr/bin/perl
use 5.14.0;

say "replacing Perl 5...";
exec qw{ /usr/bin/perl6 -e 1 }; 
die "exec failed: $!\n";
