#!/bin/bash
mkdir -p ./protein_blocks
for i in `ls *.ang`; do
    # Get name of PDB
    name=$(basename $i)
    name=$(echo "$name" | cut -f 1 -d '.')
    # Get number of commas to determine how many protein blocks we can do
    number_of_commas=`cat $name.ang| tr -cd , | wc -c`
    j=$((number_of_commas / 2))
    # Change five by three because the two last Amino acids are missing with five. For example, for protein 1A3C, with j-5 last Amino acids are I, Y and E, N are missing. If we correct with 3 last amino acids are E and N.
    j=$((j-3))
    for((num=1;num<=$j;num++));do
        head -n1 $name.ang| cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.csv
        tail -n1 $name.ang| cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.csv
    done
done
