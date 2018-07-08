#!/usr/local/bin/perl
use strict; use warnings;
use Digest::SHA;
#######################################
# SCRUB - output sha-stamped-lists
#######################################
my ($pool)=@ARGV;
die "ARG1 pool-name" if (!defined $pool);
my $date = time;
my $stamp = $pool.'_'.$date;
my $new = '/net/'.$pool.'_LIST';
#######################################
open(my $nfh, '>', $new);
opendir(my $dh, $dir) or die "FAIL opendir $dir";
#######################################
my @list = readdir $dh;
closedir $dh; chomp @list;
#######################################
for (@list)
{
	my $file = $_;
	my $sha=file_digest($file) or die "couldn't sha $file";
#######################################
	$file =~ s/.*\///;
#######################################
      	if ($sha ne $file) 
		{ print "FAIL $file\n"; next; }
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
