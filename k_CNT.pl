#!/usr/local/bin/perl
use strict; use warnings;
##################################
# CNT - count files in pool
##################################
my $cnt=0;
my ($dir) = @ARGV;
die "ARG1 DIR" if (!defined $dir);
##################################
opendir(my $dh, $dir) or die "FAIL $dir\n";
##################################
$cnt++ while (readdir $dh);
print "$cnt\n";
##################################
