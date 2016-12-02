#!/usr/local/bin/perl
# LIST FILES RECURSIVELY WITH ITS SHA256
# skrp Prince of Archives
use strict;
use warnings;
use File::Find::Rule;
use Digest::SHA ();
use Parallel::ForkManager;
##########################
# USAGE
my ($target, $shalog) = @ARGV;
if (not defined $target) {die "usage: DIR TO SCAN ARGV[0] & shalog argv[1]"; }
if (not defined $shalog) {die "usage: dir to scan argv[0] & SHALOG ARGV[1]"; }
open(my $lfh, '>>', $shalog) or die "couldn't open shalog argv[1]";
###########################
# JOBS
use constant JOBS => 1000;
use constant MAX_PROC => 4;
############################
# FIND FILES RECURSIVE
my $rule = File::Find::Rule->file()->start($target);
my $manager = Parallel::ForkManager->new(MAX_PROC);
$manager->set_waitpid_blocking_sleep(0);
my @spool;
while(defined(my $file = $rule->match)) {
  push @spool, $file;
  run_spooled() if JOBS <= @spool;
}
run_spooled() if @spool;
$manager->wait_all_children;
###########################
# ACTION FN
sub run_spooled {
  my (@jobs)=splice @spool, 0, JOBS, ();
  my $pid=$manager->start and return;
  for my $file (@jobs) {
    my ($sha) = file_digest($file) or die "couldn't sha $file";
    print {$lfh} "$sha $file\n";
    }
    $manager->finish;
}
########################
# SHA FN
sub file_digest {
    my ($filename) = @_;
    my $digest = Digest::SHA->new(256);
    $digest->addfile($filename, "b");
    return $digest->hexdigest();
}
