use strict; use warnings;
# FILT - grep metadata interface
#   feat. ningu irc.freenode.net
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
my @masterkeyset = keys %{$map{$commands[0]}};
my @newkeyset = @masterkeyset;
# USER INPUT
while (1) {
    print "usage: type string; reset; print;\n";
    print "MKRX SYSTEMS RDY: ";
    my $input = <STDIN>; chomp $input;
    print "\nwork'n on $input\n";
    my ($cmd, $string) = split(' ', $input, 2);
 
    if ($cmd eq 'reset')
        { @newkeyset = @masterkeyset; }
    elsif ($cmd eq 'print') {
        foreach my $key (@newkeyset)
            { print $keyfile "$key\n"; }
    }
    elsif ($map{$cmd})
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
    my $sub_hash = $map{$cmd};
    @newkeyset = grep { $sub_hash->{$_} =~ /$string/i } @newkeyset;
   
    foreach my $key (@newkeyset)
        { print "$key\n"; }
}

