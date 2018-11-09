#!/usr/local/bin/perl
use strict; use warnings;
#################################
# initNEST - create the nested location
#################################
my ($target) = @ARGV;
die "ARG1 target\n" unless (defined $target);
$target =~ s%/\z%%;
#################################
my @one = qw(a b c d e f 1 2 3 4 5 6 7 8 9 0);
my @two = qw(a b c d e f 1 2 3 4 5 6 7 8 9 0);
#################################
for (one)
{
  my $i = $target.'/'.$_;
  system("mkdir $i$_") for (@two);
}
