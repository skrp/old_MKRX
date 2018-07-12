#!/usr/local/bin/perl
use strict; use warnings;
use File::Path; use File::Copy;
use Digest::SHA qw(sha256_hex); 
use Time::HiRes 'gettimeofday', 'tv_interval';
######################################################
# BLKR - shreds file into standard-sized blocks

# INIT ###############################################
my ($que, $path) = @ARGV;
if (not defined $que) { die ('NO ARGV1 que'); }
if (not defined $path) { die ('NO ARGV2 dir'); }
if (substr($path, -1) ne "/")
	{ $path .= '/'; }

# DIRS ###############################################
# sea/ : blkr()
# key/ : key()
# graveyard/ : tombstone()
# g/ : XS()
# pool/ : XS()

# PREP ###############################################
my $name = name();
chdir('/tmp/');
my $RATE = 100; 
my $size = 128000;
my $count = 0;

my $dump = "$name"."_dump/";
my $log = "$name"."_log";

mkdir $dump or die "dump FAIL\n";
open(my $Lfh, '>>', $log);
my $born = gmtime();
my $btime = TIME(); 
print $Lfh "HELLOWORLD $btime\n";

# WORK ################################################
open(my $qfh, '<', $que) or die "cant open que\n";
my @QUE = readline $qfh; chomp @QUE;

my $ttl = @QUE; 
print $Lfh "ttl $ttl\n"; 

foreach my $i (@QUE)
{
	print $Lfh "started $i\n";
	blkr($i);
	$count++;
	if ($count % 100 == 0)
		{ print "$count : $ttl\n"; }
}
my $dtime = TIME(); print $Lfh "FKTHEWRLD $dtime\n";

# SUB ###########################################################
sub TIME
{
	my $t = localtime;
	my $mon = (split(/\s+/, $t))[1];
	my $day = (split(/\s+/, $t))[2];
	my $hour = (split(/\s+/, $t))[3];
	my $time = $mon.'_'.$day.'_'.$hour;
	return $time;
}
sub name
{
	my $id = int(rand(999));
	my $name = $$.'_'.$id;
	return $name;
}
# API ###########################################################
sub blkr
{
	my ($i) = @_;
	my $block = 0;
	my $ipath = $path.'pool/'.$i;
	open(my $ifh, '<', "$ipath") || die "Cant open $i: $!\n";
	binmode($ifh);
	
	my $istart = gettimeofday();
	my $cunt = 0;
	while (read($ifh, $block, $size))
	{
		my $bsha = sha256_hex($block);
		my $bname = $path.'sea/'.$bsha;
		open(my $fh, '>', "$bname");
		binmode($fh);

		print $fh $block;
		key($i, $bsha);
		$cunt++;
	}
	print $Lfh "YAY $i\n";

	my $elapsed = gettimeofday()-$istart;
	print "$i : $cunt : $elapsed \n";	
}
sub key
{
	my ($i, $bsha) = @_;
	my $kpath = $path.'key/'.$i;
	open(my $kfh, '>>', "$kpath");
	print $kfh "$bsha\n";
}
