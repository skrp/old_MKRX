use strict; use warnings;
##############################################
# LONE - discover unduplicated files
my @lines;
my $hn = system("hostname");

open(my $cfh, '<', "/net/$hn");
@lines = readline $cfh;
close $cfh; chomp @lines;

for (@lines)
{
  my @array = split(" ", $_};
  my $cnt =  0;
  
  $cnt++ for (@array);
#  print "$array[0]\n" if (($cnt == 2) && ($array[1] eq $pool));
  print "$array[0] $array[1]\n" if ($cnt == 2);
}
