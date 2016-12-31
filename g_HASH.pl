#!/usr/local/bin/perl
# HASH - populate hash files via metadata
# by skrp of MKRX
use strict; use warnings;
use File::Find::Rule;

my ($target) = @ARGV;
my $rule = File::Find::Rule->file()->start($target);
# CREATE HASH-FILES
my $nnfd = 'NAM';
my $ppfd = 'PAT';
my $zzfd = 'SIZ';
my $eefd = 'ENC';
open(my $nfd, '>>', $nnfd);
open(my $pfd, '>>', $ppfd);
open(my $zfd, '>>', $zzfd);
open(my $efd, '>>', $eefd);
# POPULATE HASH-FILES
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
