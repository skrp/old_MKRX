#!/usr/local/bin/bash
#
###################
# Shred Into Blocks
###################
#
# LOCATIONS
# $target/ = files will be shredded into 1M blocks
# $dump/ = working directory
# $dump/pool/ = final location 
# $dump/limbo/ = temporary location for split
# $dump/keys/ = ordered file pieces
#
# USAGE
if (( $# != 2 ))
then
	printf"\nUsage: \n";
	printf "ARG1 - Dir to Split\n";
	printf "ARG2 - Dir to Dump\n";
	exit 1;
fi
#
# VARIABLES
target=${1%/}
dump=${2%/}

[[ -d "$target" ]] || { echo "INVALID SPLIT DIR"; exit 1; }
[[ -d "$dump" ]] || { echo "INVALID DUMP DIR"; exit 1; } 

for line in $target/*
do
	printf "$line\n";
	wsha=$( sha256 "$line" | awk '{ print $NF }' )
	split -a 6 -d -b 100000 "$line" "$dump"/todo/;
	touch "$dump"/key/"$wsha";
	printf "" > "$dump"/temp;
	list=$( ls "$dump"/todo/ )
	for i in $list
		do
		psha=$( sha256 "$dump"/todo/"$i" | awk '{ print $NF }' )
		printf "%s\n" "$psha" >> "$dump"/key/k"$wsha";
		mv "$dump"/todo/"$i" "$dump"/processed/"$psha";
		cat "$dump"/processed/"$psha" >> "$dump"/temp;
		done
	tmp=$( sha256 "$dump"/temp | awk '{ print $NF }' )
	if [ "$wsha" == "$tmp" ]
		then printf "SUCCESS $tmp\n";
		else printf "FAIL SHA RECHECK $line" >> "$dump"/fails;
	fi
done
