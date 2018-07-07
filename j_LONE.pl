use strict; use warnings;
#########################################
# LONE - discover unduplicated files

my ($file, $pool) = @ARGV;
die "ARG1 file  ARG2 pool" if (!defined $pool);

open(my $fh, '<', $file);
my @lines = readline $fh;
close $fh; chomp @lines;

for (@lines)
{
  my @array = split(" ", $_};
  my $cnt =  0;
  
  $cnt++ for (@array);
  print "$array[0]\n" if (($cnt == 2) && ($array[1] eq $pool));
}
