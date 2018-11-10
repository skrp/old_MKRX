#!/usr/local/bin/perl
use strict; use warnings;
#####################################################
# CENSUS - locations of files
# each disk node lists one file per line
#    example: vu2_LIST -> aa12...\naa2b..
#####################################################
my ($dir) = @ARGV;
die "ARG1 dir\n" unless (defined $dir);
$dir =~%/\z%%;
#####################################################
my %LIST;
my @list;
#####################################################
@list = glob("$dir/*_LIST");
shift @list; shift @list;
#####################################################
for (@list)
{
  my $ifile = $_;
  open(my $ifh, '<', $ifile);
  my @i = readline $ifh;
  close $ifh; chomp @i;
#####################################################
  my $node = $ifile;
  $node =~ s/_LIST//;
  $node =~ s%.*/%%;
#####################################################
  for (@i)
  {
    my $iline = $_;
    $LIST{$iline} .= " $node";
  }
}
#####################################################
print "$_$LIST{$_}\n" for (keys %LIST);
