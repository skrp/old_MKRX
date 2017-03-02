#!/usr/local/bin/perl
use strict; use warnings;
use File::Find::Rule;
####################################
# HASH - populate hash via metafiles
####################### skrp of MKRX
# SETUP ############################
my ($target) = @ARGV;
my $rule = File::Find::Rule->file()->start($target);
# comment out to reduce massive size in memory
my $nnfd = 'NAM';
open(my $nfd, '>>', $nnfd);
my $ppfd = 'PAT';
open(my $pfd, '>>', $ppfd);
my $zzfd = 'SIZ';
open(my $zfd, '>>', $zzfd);
my $eefd = 'ENC';
open(my $efd, '>>', $eefd);
# POPULATE HASH METAFILES ###########
while (defined(my $file = $rule->match)) {
	open(my $fd, '<', $file); 
	my @f = readline $fd;
	chomp @f;
	my $fsha = $file =~ s%.*\/%%r;
	print $nfd "$fsha $f[0]\n";
	print $pfd "$fsha $f[1]\n";
	print $zfd "$fsha $f[2]\n";
	print $efd "$fsha $f[3]\n";
	close $fd;
}
