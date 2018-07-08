#!/usr/local/bin/perl
use strict; use warnings;
#########################################
# BORED - idle massive output
#########################################
my $gfh;
my @color = qw(blue yellow cyan magenta);
my @g;
my $rset = 0;
my $hn = system("hostname");
#########################################
if (-e '/tmp/BORED') 
 { open(my $gfh, '<', '/tmp/BORED'); }
else 
 { open(my $gfh, '<', "/net/$hn"); }
#########################################
@g = readline $gfh;
close $gfh; chomp @g;
#########################################
print "TTL: @g\n";
while ($i = shift @g)
{
  sleep 1;
#########################################  
  my $color = $color[rand @color]; 
#########################################  
  print color 'red';
  my @i = split(" ", $i);
  print "$i[0]";
#########################################  
  print color $color;
  print " $_" for (@i);
  print "\n";
#########################################
  print color 'white';
  print "0\n0\n0\n0\n";
  print color 'reset';
#########################################  
  if ($rset % 100000 == 0)
  {
    open(my $tfh, '>', '/tmp/BORED');
    print $tfh "$_\n" for @g;
    close $tfh;
  }
#########################################  
  $rset++;
}
