#!/usr/bin/perl
use 5.14.0;

say "start $$";
fork;
say "done $$";

wait; # and see...
