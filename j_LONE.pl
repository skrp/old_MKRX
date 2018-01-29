use strict; use warnings;
use File::Find::Rule;

#########################################
# LONE - discover unduplicated files

my ($host_path) = @ARGV;

while (defined File::Find::Rule->file()->in($host_path))
{
  open(my $ifh, '<', $_);
  my @i = readline $ifh; 
  close $ifh; chomp @i;
  for (@i)
  { 
# CLONE COUNT ###########################
    my $c = $LIST{$_};
    $c++;
    $LIST{$_} = $c;
  }
}
# STDOUT ################################
for (keys %LIST)
{
  my $c = $LIST{$_};
  print "$_\n" if ($i == 1);
}
