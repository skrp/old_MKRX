#!/usr/local/bin/perl
use strict; use warnings;
###########################
# MV - move a list of files
use File::Copy;
###########################
my ($list, $target, $dump) = @ARGV;
die "ARG1 list ARG2 target ARG3 dump" if (!defined $dump);
$dir =~ s%/\z%%;
###########################
open(my $lfh, '<', $list);
my @list = readline $lfh;
close $lfh; chomp @list;
###########################
my $cnt = 0;
for my $line (@list)
{
###########################
  if (-e $f)
    { move($f, $dump) or printf("FAIL %s cnt: %d\n", $f, $cnt++); }
}
###########################
