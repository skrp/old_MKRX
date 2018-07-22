#!/usr/local/bin/perl
use strict; use warnings;
use Digest::SHA;
#######################################
# SCRUB - output sha-stamped-lists
#######################################
my ($node, $pool, $log)=@ARGV;
die "ARG1 node ARG2 location ARG3 log" if (!defined $log);
$pool =~ %/\z%%;
my $date = time;
my $stamp = $node.'_'.$date;
my $error = $log.'_ERROR';
#######################################
open(my $efh, '>>', $error);
open(my $nfh, '>', $new);
opendir(my $dh, $dir) or die "FAIL opendir $dir";
#######################################
my @list = readdir $dh;
closedir $dh; chomp @list;
#######################################
for (@list)
{
	my $file = $_;
	$file =~ $pool.'/'.$file;
	my $sha=file_digest($file) or die "FAIL sha $file";
#######################################
	$file =~ s/.*\///;
#######################################
      	if ($sha ne $file) 
		{ print $efh "FAIL sha $node $file\n"; next; }
#######################################	
	print $nfh "$file $stamp\n";
}
#######################################
sub file_digest 
{
    my ($filename)=@_;
    my $digest=Digest::SHA->new(256);
    $digest->addfile($filename, "b");
    return $digest->hexdigest();
}
