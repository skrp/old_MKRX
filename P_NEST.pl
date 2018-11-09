#!/usr/local/bin/perl
use strict; use warnings;
use File::Copy;

my ($work, $target, $dump) = @ARGV;
die "ARG1 work-dir ARG2 target ARG3 dump\n" unless (-d $dump);

$target =~ s%/\z%%;
$work =~ s%/\z%%;
$dump =~ s%/\z%%;

opendir(my $dh, $work);
my @work = readdir $dh;

shift @work; shiftt @work;

for (@work)
{
  my $list = $wowrk.'/'.$_;
  open(my $lfh, '<', $list);
  my @list = <$lfh>;
  chomp @list; close $lfh;
  
  my $cnt = 0;
  for my $line (@list)
  {
    $cnt++;
    my $f = 
