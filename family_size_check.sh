#!/bin/bash

module load BEDTools/2.25.0-foss-2015b 

for i in *gff
do
# Change the position of gff output, combine the family name and gene name together, put it as the name of new file
    awk '{print $9 "" $10 "_" $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' $i > $i.use

# First sort by first column (name), then sort by start coordinate
    sort -k1,1 -k4,4n lu > $i.use > sorted_$i.use

# Merge coordinates that overlapped based on the name (first column)
    mergeBed -c 1 -o collapse -i sorted_$i.use > merged_$i.use

# Separate the family name and gene name
    sed 's/_S/\t/g' merged_$i.use > temp_$i

# Sums up the piles for each family
    perl frequency_check.pl temp_$i > times_$i
done

