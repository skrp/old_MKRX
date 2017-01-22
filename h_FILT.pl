#!/usr/local/bin/perl
use strict; use warnings;
# FILT - grep metadata interface DAEMONIZE
#   feat. ningu irc.freenode.net

# ARGS & FRIENDS #####################################
my %master;
my @commands = qw(name path size encode);
die "no source directory" unless @ARGV;
my ($data_dir) = @ARGV;
die "no dir $data_dir" unless -d $data_dir;
$data_dir =~ s%/\z%%;
# POPULATE HASHES ####################################
foreach my $comm (@commands)
	{ read_file(uc substr($comm, 0, 3), $comm); }
my @masterkeyset = keys %{$master{$commands[0]}};
my @keyset = @masterkeyset;
# PROMPT #############################################
while (1) {
	prmpt();
	my $input = <STDIN>; chomp $input;
	print "\nwork'n on $input\n";
	my ($comm, $string) = split(' ', $input, 2);
# RESET ##############################################
	if ($comm eq 'reset')
		{ @keyset = @masterkeyset; }
# PRINT ##############################################
	elsif ($comm eq 'print') {
		my $pfh = crfile($string);
		foreach my $key (@keyset)
			{ print $pfh "$key\n"; }
		close $pfh;
	}
# COUNT ############################################
	elsif ($comm eq 'count')
		{ my $cnt = @keyset; print "CURRENT: $cnt\n"; }
# VALUE #############################################
	elsif ($comm eq 'value') {
		my %descript = %{$master{$string}};
		foreach my $key (@keyset)
			{ print "$descript{$key}\n"; }
	}
# GREP ##############################################
	elsif ($master{$comm})
		{ layer_s($comm, $string); }
# POPULATE ##########################################
	elsif ($comm eq 'pop') {
		my $target_size = $string;
		my %pop = %{$master{"size"}};
		my $pfh = crfile($target_size);
		my $ofh = crfile("leftover_$target_size");
		my $cur_size = 0; my @leftokeys = @keyset;
		foreach my $key (@keyset) {
			my $iter_amt = $pop{$key};
			$cur_size += $iter_amt;
			if ($cur_size < $target_size) {
				my $index = 0; 
				$index++ until $keyset[$index] eq $key;
				splice(@keyset, $index, 1);
				print $pfh "$key\n";
			}
			else { last; }
		}
		foreach my $lefto (@leftokeys) 
			{ print $ofh "$lefto\n"; }
		close $pfh; close $ofh;
	}
# DEFAULT ########################################### 
	else { print "unknown command $comm\n"; }
} # SUBS ############################################
sub read_file {
	my ($filename, $cmd) = @_;
	my $path = "$data_dir/$filename";
	open(my $fh, '<', $path) or die "Couldn't open $filename\n";
	my @lines = readline $fh; chomp @lines; close $fh;
	my %sub_hash;
	foreach my $i (@lines) {
		my @key_value = split(" ", $i, 2);
		$sub_hash{$key_value[0]} = $key_value[1];
	}
	$master{$cmd} = \%sub_hash;
}
sub layer_s {
	my ($cmd, $string) = @_;
	my $sub_hash = $master{$cmd};
	@keyset = grep { $sub_hash->{$_} =~ /$string/i } @keyset;
	foreach my $key (@keyset)
		{ print "$key\n"; }
}
sub crfile {
	my ($fname) = @_;
	my $sub_path = "$data_dir/$fname";
	if (-e $sub_path)
		{ print "$sub_path already exists"; exit; }
	open(my $sfh, '>>', $sub_path) or die "cant open $sub_path";
	print "listing save to $sub_path\n";
	return $sfh;
}
sub prmpt {
	print "usage:  type \$string  || reset  ||  print \$filename\n";
	print "        count  ||  value \$type ||  pop \$amt\n";
	print "MKRX SYSTEMS RDY: ";
}
