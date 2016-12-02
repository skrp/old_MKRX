#!/usr/local/bin/perl
# LOG ALL FILES MISSING A CORESPONDING META FILE
# skrp Prince of Archives
use strict;
use warnings;
use Parallel::ForkManager;
use List::Util 'any';
###############################
# USAGE
my ($input, $masterlist)=@ARGV;
open(my $sfh, '<', $input) or die("Can't open $input\n");
open(my $mfh, '<', $masterlist) or die("Can't open $masterlist\n");
################################
# JOBS
use constant MAX_PROC => 4;
use constant JOBS => 10000;
my $manager=Parallel::ForkManager->new(MAX_PROC);
$manager->set_waitpid_blocking_sleep(0);
################################
# ARRAYS
my @files=<$sfh>;
my @master=readline $mfh;
chomp @files;
chomp @master;
###############################
# BEGIN
my @spool;
foreach my $file (@files) {
  push @spool, $file;
  run_spooled() if JOBS <= @spool;
}
run_spooled() if @spool;
$manager->wait_all_children;
###############################
# MAIN FN
sub run_spooled {
  my (@jobs)=splice @spool, 0, JOBS, ();
  my $pid=$manager->start and return;
  foreach my $file (@jobs) {
#      my ($line) = $file =~ s/g//;
      if(any {$_ eq $line} @master) {
          next;
      }
      else {
          print {$lfh} "$file: is not in $masterlist\n";
      }
  }
  $manager->finish;
close $sfh;
close $mfh;
}
