#!/usr/local/bin/perl
use strict; use warnings;
use File::Find::Rule;

#####################################################
# CENSUS - locations of files

# List all mkrx storage nodes
# ex: bkup11_LIST

# Each node with a newline delimited file list
# FORMAT:
#        $sha $host $host $host ...

my ($host_path) = @ARGV;
die "ARG1 host_path" if (!defined $host_path);

my %LIST;
my @list = glob("$host_path/*_LIST");
my $date = time;

shift @list; shift @list; # rm . ..

for (@list)
{
  my $host = $_;
  $host =~ s?.*\/??;
  $host =~ s?_.*??;
  
  open(my $ifh, '<', $_);
  my @i = readline $ifh;
  close $ifh; chomp @i;
  
  $LIST{$_} .= " $host_$date" for (@i);
} 

print "$_$LIST{$_}\n" for (keys %LIST);
