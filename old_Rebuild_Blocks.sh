#!/usr/local/bin/bash
######################################
# Compile - rebuild file from QUI file
######################################
# USAGE
if (( $# !=2 ))
then 
  printf "\nUsage: \n";
  printf "ARG1 - File to Pull from\n";
  printf "ARG2 - Directory to Dump\n";
  exit 1
fi
#
# ARGUMENTS
QUI=${1%/}
dump=${2%/}
#
# LOCATIONS
# $target/ = files will be shredded into 1M blocks
# $dump/ = working directory
# $dump/pool/ = final location 
# $dump/limbo/ = temporary location for split
# $dump/QUI/ = ordered file pieces
# $dump/output/ = recompiled files
#
# BEGIN
whole=$( cat $QUI );

for part in $whole
do
    cat "$dump"/pool/"$part" >> "$dump"/limbo/completed;
done
wsha=$( sha256 /"$dump"/limbo/completed | awk '{ print $NF }' )
mv "$dump"/limbo/completed "$dump"/output/"$wsha";
