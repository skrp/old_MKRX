#!/usr/local/bin/perl
use strict;use warnings;
# Xtract & Standardize - rip recursive standardization
# - - - - - - - - feat. https://github.com/kentfredric
use File::Find::Rule;
use Digest::SHA ();
use Parallel::ForkManager;
use File::Copy;
use File::LibMagic;

########################
# USAGE
my ( $target, $dump ) = @ARGV;
if ( not defined $target ) { die "usage: TARGET ARGV[0] & dump argv[1]"; }
if ( not defined $dump ) { die "usage: target argv[0] & DUMP ARGV[1]"; }

#########################
# JOBS
use constant JOBS_PER_WORKER => 1000;
use constant MAX_PROCESSES => 4;

############################
# RETURN ALL FILES RECURSIVE
my $rule = File::Find::Rule->file()->start($target);
my $manager = Parallel::ForkManager->new(MAX_PROCESSES);
my $magic = File::LibMagic->new();

$manager->set_waitpid_blocking_sleep(0);

my @spool;
while ( defined( my $file = $rule->match ) ) {
	push @spool, $file;
	run_spooled() if JOBS_PER_WORKER <= @spool;
}

run_spooled() if @spool;

$manager->wait_all_children;

sub run_spooled {
	my (@jobs) = splice @spool, 0, JOBS_PER_WORKER, ();

	my $pid = $manager->start and return;
	for my $file (@jobs) {
		my ($sha) = file_digest($file) or die "couldn't sha $file";
		File::Copy::copy( $file, "$dump/pool/$sha");
		my $cur = "$dump/g/g$sha";
		open my $fh, '>>', $cur or die "Meta File Creation FAIL $file";
		printf {$fh} "%s\n%s\n%s\n%s\n", 
			name($file),
			path($file),
			size($file),
			file_mime_encoding($file);
	}
	
	$manager->finish;
}

sub file_digest {
	my ($filename) = @_;
	my $digester = Digest::SHA->new('sha256');
	$digester->addfile( $filename, 'b' );
	return $digester->hexdigest;
}

sub name {
	my ($filename) = @_;
	$filename =~ s#^.*/##;
	return $filename;
}

sub path {
	my ($filename) = @_;
	$filename =~ s#/#_#g;
	return $filename; 
}

sub file_mime_encoding {
	my ($filename) = @_;
	my $info = $magic->info_from_filename($filename);
	my $des = $info->{description};
	$des =~ s#[/ ]#.#g;
	$des =~ s/,/_/g;
	my $md = $info->{mime_type};
	$md =~ s#[/ ]#.#g;
	my $enc = sprintf("%s %s %s", $des, $md, $info->{encoding}); 
	return $enc;
}
	
sub size {
	my $size = [ stat $_[0] ]->[7];
	return $size;
}
