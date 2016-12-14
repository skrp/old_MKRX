#!/usr/local/bin/perl
use strict; use warnings;
use Term::ANSIColor;
my ($data) = @ARGV;
# POPULATE HASHES;
my $ndata = $data . '/NAM';
open(my $nam, '<', $ndata) or die ("Couldn't open NAM\n");
my @name = readline $nam;
chomp @name;
my %name;
foreach my $i (@name) {
	my @n = split(" ", $i);
	$name{$n[0]} = $n[1];
}
my $pdata = $data . '/PAT';
open(my $pat, '<', $pdata) or die ("Couldn't open PAT\n");
my @path = readline $pat;
chomp @path;
my %path;
foreach my $i (@path) {
	my @p = split(" ", $i);
	$path{$p[0]} = $p[1];
}
my $zdata = $data . '/SIZ';
open(my $siz, '<', $zdata) or die ("Couldn't open SIZ\n");
my @size = readline $siz;
chomp @size;
my %size;
foreach my $i (@size) {
	my @z = split(" ", $i);
	$size{$z[0]} = $z[1];
}
my $edata = $data . '/ENC';
open(my $enc, '<', $edata) or die ("Couldn't open ENC\n");
my @encode = readline $enc;
chomp @encode;
my %encode;
foreach my $i (@encode) {
	my @e = split(" ", $i);
	$encode{$e[0]} = $e[1];
}
# USER INPUT
START:
print color('bold yellow');
print "MKRX SYSTEMS RDY!\n: ";
print color('reset');
my $input = <STDIN>;
chomp($input);
print "\nwork'n on $input\n";
# OPTIONS
my @cmds = (split ' ', $input)[0,1];
my $cmd = $cmds[0];
my $string = $cmds[1];
# ACTION
if ($cmd eq 'name') {
		my @resname = grep { $name{$_} eq $string } keys %name;
		foreach my $resname (@resname) {
			print "$resname\n";
		}
		goto START;
	}
elsif ($cmd eq 'path') {
		my @respath = grep { $path{$_} eq $string } keys %path;
		foreach my $respath (@respath) {
			print "$respath\n";
		}
		goto START;
	}
elsif ($cmd eq 'size') {
		my @ressize = grep { $size{$_} eq $string } keys %size;
		foreach my $ressize (@ressize) {
			print "$ressize\n";
		}
		goto START;
	}
elsif ($cmd eq 'enco') {
		my @resenco = grep { $encode{$_} eq $string } keys %encode;
		foreach my $resenco (@resenco) {
			print "$resenco\n";
		}
		goto START;
	}
else {
	print "\nARGV1: TYPE\nARGV2: PATTERN\n";
	goto START;
}
