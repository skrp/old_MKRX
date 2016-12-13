#!/usr/local/bin/perl
# # METACHK - confirm uniq file has meta
# by skrp of MKRX
use strict;
use warnings;

my ($fmaster, $mmaster) = @ARGV;
open(my $ffp, '<', $fmaster) or die ("Couldn't open filemaster\n");
open(my $mfp, '<', $mmaster) or die ("Couldn't open metamaster\n");

my @file = readline $ffp;
my @meta = readline $mfp;
chomp @file;
chomp @meta;

my %mkrx = map{$_ => undef} @file;

foreach my $meta (@meta) {
	my $f = $meta =~ s/g//r;
	$mkrx{$f} = $meta;
}
# UNDEF SCAN
while (my ($key, $value) = each %mkrx) {
	if (not defined $mkrx{$key} ) { print "$key: NEEDS FILE\n"; }
}
# COUNT
print "SICC POOL COUNT:\n";
my $size = keys %mkrx;
print "$size\n";

######################

exit 0;
 
