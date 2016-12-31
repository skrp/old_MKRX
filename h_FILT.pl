#!/usr/local/bin/perl
# FILT - regex browser of metadata masterlists
use strict; use warnings;
my %map;
my @commands = qw(name path size encode);
die "no source directory" unless @ARGV;
my ($data_dir) = @ARGV;
die "no dir $data_dir" unless -d $data_dir;
my $key_path = "$data_dir/latest";
open(my $keyfile, '>>', $key_path) or die "couldn't open latest";
# POPULATE HASHES
foreach my $cmd (@commands)
    { read_file(uc substr($cmd, 0, 3), $cmd); }
#my @masterkeyset = keys %{$map{(keys %map)[0]}}; # derp dont know what this does
my @newkeyset;
# USER INPUT
while (1) {
    print "usage: type string; reset; print;\n";
    print "MKRX SYSTEMS RDY: ";
    my $input = <STDIN>; chomp $input;
    print "\nwork'n on $input\n";
    my ($cmd, $string) = split(' ', $input, 2);

    if ($cmd eq 'reset')
        { @newkeyset =(); next; }
    if ($cmd eq 'print') {
        foreach my $key_item (@newkeyset)
            { print $keyfile "$key_item\n"; next; }
    }
    if ($map{$cmd})
        { layer_s($cmd, $string); }
    else
        { print "unknown command $cmd\n"; }
} ################################################
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
    $map{$cmd} = \%sub_hash;
}
sub layer_s {
    my ($cmd, $string) = @_;
    my $m = $map{$cmd};
    @newkeyset = grep { $m->{$_} =~ /$string/i } @newkeyset;
    foreach my $r_key (@newkeyset)
        { print "$r_key\n"; }
}
