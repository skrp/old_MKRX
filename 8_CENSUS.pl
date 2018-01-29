#!/usr/local/bin/perl
use strict; use warnings;
use File::Find::Rule;

my ($host_path) = @ARGV;
die "ARG1 host_path" if (!defined $host_path);

my %LIST;

while (defined File::Find::Rule->file()->ine($host_path);
