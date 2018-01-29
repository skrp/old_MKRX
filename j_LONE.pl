use strict; use warnings;
use File::Find::Rule;

#########################################
# LONE - discover unduplicated files

my ($host_path) = @ARGV;

while (defined File::Find::Rule->file()->in($host_path))
{
