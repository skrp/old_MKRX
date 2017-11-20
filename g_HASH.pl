#!/usr/local/bin/perl
use strict; use warnings;
use File::Find::Rule;
####################################
# HASH - populate hash via metafiles
####################### skrp of MKRX
# SETUP ############################
my ($target) = @ARGV;
# test for last '/' of $targe
my $rule = File::Find::Rule->file()->start($target);
# comment out unused categories to reduce massive size in memory 
my $nnfd = $target.'NAM';
my $ppfd = $target.'PAT';
my $zzfd = $target.'SIZ';
my $eefd = $target.'ENC';
open(my $nfd, '>>', $nnfd);
open(my $pfd, '>>', $ppfd);
open(my $zfd, '>>', $zzfd);
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
