#!/usr/local/bin/perl
# SCRUB CRONJOB
# skrp Prince of Archives
use strict;
use warnings;
use Digest::SHA ();
use List::Util 'any';
###############################
# USAGE
my ( $input, $masterlist, $log) = @ARGV;
open(my $sfh, '<', $input) or die("Can't open $input\n");
open(my $mfh, '<', $masterlist) or die("Can't open $masterlist\n");
open(my $lfh, '>>', $log) or die("Can't open $log\n");
################################
# ARRAYS
my @files = <$sfh>;
my @master = readline $mfh;
chomp @files;
###############################
# BEGIN
foreach my $file (@files) {
      $true = file_digest($file) or die "couldn't sha $file";
      if( any {$line} @master ) {
          next;
      }
      else {
          print {$lfh} "$file: is not in $masterlist\n";
      }
close $mfh;
close $sfh;
close $lfh;
}

sub file_digest {
  my ($filename) = @_;
  my $digester = Digest::SHA->new('sha256');
  return $digester->hexdigest;
}
