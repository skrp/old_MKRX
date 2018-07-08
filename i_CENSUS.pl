#!/usr/local/bin/perl
use strict; use warnings;
#####################################################
# CENSUS - locations of files
#####################################################
my %LIST;
my @list;
#####################################################
@list = glob("/net/*_LIST");
shift @list; shift @list;
#####################################################
for (@list)
{
  my $ifile = $_;
  open(my $ifh, '<', $ifile);
  my @i = readline $ifh;
  close $ifh; chomp @i;
#####################################################
  for (@i)
  {
    my $iline = $_;
    my @line = split(" ", 2, $iline);
    $LIST{$line[0]} .= " $line[1]";
  }
}
#####################################################
print "$_$LIST{$_}\n" for (keys %LIST);
