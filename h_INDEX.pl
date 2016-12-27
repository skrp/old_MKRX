#!/usr/local/bin/perl
use strict; use warnings;
# INDEX - create metadata dumps
use File::Find::Rule;

my ($g_dir, $dump_dir) = @ARGV;
if (not defined $g_dir) {die "USAGE: ARGV1 g dir ARGV2 dump dir";}
if (not defined $dump_dir) {die "USAGE: ARGV1 g dir ARGV2 dump dir";}

$dump_dir =~ s%/\z%%;
my $NAME = "$dump_dir/NAM";
my $PATH = "$dump_dir/PAT";
my $SIZE = "$dump_dir/SIZ";
my $ENCODE = "$dump_dir/ENC";
open(my $nam, '>>', $NAME) or die ("Couldn't open NAM");
open(my $pat, '>>', $PATH) or die ("Couldn't open PAT");
open(my $siz, '>>', $SIZE) or die ("Couldn't open SIZ");
open(my $enc, '>>', $ENCODE) or die ("Couldn't open ENC");

my $rule = File::Find::Rule->file()->start($g_dir);

while (defined(my $file = $rule->match)) {
	open(my $ifh, '<', $file) or die "couldn't open $file\n";
	my @tmp = readline $ifh; chomp @tmp;
	print $nam "$tmp[0]\n";	
	print $pat "$tmp[1]\n";	
	print $siz "$tmp[2]\n";	
	print $enc "$tmp[3]\n";	
	close $ifh;
}
close $nam; close $pat; close $siz; close $enc;
print "INDEX POPULATED\n";
