#!/usr/local/bin/perl
use strict; use warnings;
use File::Find::Rule;
######################################################
# HASH - scrape metadata-files to metadata masterfiles
########################################## skrp of MKRX
# this process is io intensive
# format of each metadata masterfile => "file-sha metadata-value\n"
# EXAMPLE: "922440e6b538bc9e7dd72b58084d2712cd770f61f370261f5bf6528b5f8d3083 FreeBSD-10.3-RELEASE-amd64-memstick.img\n" >> NAM

# SETUP #############################################
# ARG1 is the metadata directory
my ($metadata_dir) = @ARGV;
die "ARG1 metadata dir" if (!defined $metadata_dir);

my $rule = File::Find::Rule->file()->start($metadata_dir);

my $nmaster = 'NAM';
open(my $nfd, '>>', $nmaster);
my $pmaster = 'PAT';
open(my $pfd, '>>', $pmaster);
my $zmaster = 'SIZ';
open(my $zfd, '>>', $zmaster);
my $emaster = 'ENC';
open(my $efd, '>>', $emaster);

# POPULATE HASH METAFILES ##################
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
