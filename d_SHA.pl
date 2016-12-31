#!/usr/local/bin/perl
# SHA - extract sha recursively
# by skrp of MKRX
##################################
use strict; use warnings;
use File::Find::Rule;
use Digest::SHA ();
##########################
# USAGE
my ($target, $shalog) = @ARGV;
if (not defined $target) {die "usage: DIR TO SCAN ARGV[0] & shalog argv[1]"; }
if (not defined $shalog) {die "usage: dir to scan argv[0] & SHALOG ARGV[1]"; }
open(my $lfh, '>>', $shalog) or die "couldn't open shalog argv[1]";
############################
# FIND FILES RECURSIVE
my $rule = File::Find::Rule->file()->start($target);
my %response;
while(defined(my $file = $rule->match)) {
    my ($sha) = file_digest($file) or die "couldn't sha $file";
    $response{$file} = $sha;	
}
while (my ($key, $value) = each %response) 
	{ print $lfh "$value:  $key\n"; }
########################
# SHA FN
sub file_digest {
    my ($filename) = @_;
    my $digest = Digest::SHA->new(256);
    $digest->addfile($filename, "b");
    return $digest->hexdigest();
}
