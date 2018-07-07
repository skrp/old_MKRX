#!/usr/local/bin/perl
use strict; use warnings;
###############################
# BEEP - drive blinker
my ($drive) = @ARGV;

while (1)
{
  system("dd if=/dev/$drive of=/dev/null");
  sleep 2;
  system("dd if=/dev/$drive of=/dev/null");
  sleep 1;
  print "fktheworld\n";
}
