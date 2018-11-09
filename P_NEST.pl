#!/usr/local/bin/perl
use strict; use warnings;
use File::Copy;
###################################
# NEST - create nested directories for files
###################################
my ($work, $target, $dump) = @ARGV;
die "ARG1 work-dir ARG2 target ARG3 dump\n" unless (-d $dump);
###################################
$target =~ s%/\z%%;
$work =~ s%/\z%%;
$dump =~ s%/\z%%;
###################################
opendir(my $dh, $work);
my @work = readdir $dh;
###################################
shift @work; shift @work;
###################################
for (@work)
{
  my $list = $work.'/'.$_;
  open(my $lfh, '<', $list);
  my @list = <$lfh>;
  chomp @list; close $lfh;
###################################  
  my $cnt = 0;
  for my $line (@list)
  {
    $cnt++;
    my $f = "$dir/$line";
###################################    
    if (-e $f)
    {
      my $pre = substr($line,0,2);
      my $loc = $dump.'/'.$pre.'/';
      copy($f, $loc) or print "$! $f FAIL $cnt\n";
    }
 }
}
