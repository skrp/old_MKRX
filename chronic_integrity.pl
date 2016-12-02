#!/usr/local/bin/perl
# FIVE DOLLAR SCRUB CRONJOB
# skrp Prince of Archives
use strict;
use warnings;
use Digest::SHA ();
use File::Find::Rule;
###############################
# USAGE
my ( $dir, $log) = @ARGV;
open(my $lfh, '>>', $log) or die("Can't open $log\n");
###############################
# BEGIN
my $rule=File::Find::Rule->file()->start($dir);
while (defined(my $file=$rule->match)) {
      my $orgi = $file;
      my $sha = file_digest($file) or die "couldn't sha $file";
      if ($sha eq $orgi) {
            next;
      }
      else {
            print {$lfh} "$file: ALERT FKN ENTROPY!\n";
      }
}
sub file_digest {
  my ($filename) = @_;
  my $digester = Digest::SHA->new('sha256');
  return $digester->hexdigest;
}
