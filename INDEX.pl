#!/usr/local/bin/perl
# INDEX - cmp sha against uniq list
# by skrp of MKRX
use strict;
use warnings;
my ($pmaster, $mmaster, $log) = @ARGV;
open(my $pfp, '<', $pmaster) or die ("Couldn't open partialmaster\n");
open(my $mfp, '<', $mmaster) or die ("Couldn't open master\n");
open(my $lfp, '>>', $log) or die;
my @pfile = readline $pfp;
my @mfile = readline $mfp;
chomp @pfile;
chomp @mfile;
my %mkrx = map{$_ => undef} @mfile;
foreach my $p (@pfile) {
	if (exists $mkrx{$p}) { next; }
	else { print $lfp "$p\n"; }
}
