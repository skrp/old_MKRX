#!/usr/local/bin/perl
use strict; use warnings;
use Digest::SHA ();
#######################################
# SCRUB - output sha-stamped-lists
my ($pool)=@ARGV;
open(my $lfh, '>>', $log) or die("Can't open $log\n");
###############################
# BEGIN
my $rule=File::Find::Rule->file()->start($dir);
while (defined(my $file=$rule->match)) {
      my $sha=file_digest($file) or die "couldn't sha $file";
	$file =~ s/.*\///;
      if ($sha eq $file) { next; }
      else {  print {$lfh} "$file: ALERT FKN ENTROPY!\n"; }
}
sub file_digest {
    my ($filename)=@_;
    my $digest=Digest::SHA->new(256);
    $digest->addfile($filename, "b");
    return $digest->hexdigest();
}
