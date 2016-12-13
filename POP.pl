#!/usr/local/bin/perl
# POP.pl - use list to populate dump
# by skrp of MKRX
##########################
use strict; use warnings;
use File::Copy;

my ($list, $dump, $log) = @ARGV;
open(my $lfp, '<', $list) or die "Can't open list";
open(my $logfp, '>>', $log) or die "Can't open log";
my @list = readline $lfp; chomp @list;

foreach my $i (@list) {
	if (copy ($i, $dump)) { next; }
	else { print $logfp "$i: not copied\n"; }
}

my $count = @list;
print "files: $count\nI gracefully exit\n"; exit 0;
