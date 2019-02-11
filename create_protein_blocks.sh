#!/bin/bash
rm -rf ./protein_blocks
mkdir -p ./protein_blocks
for i in `ls *.ang`; do
    # Get name of PDB
    name=$(basename $i)
    name=$(echo "$name" | cut -f 1 -d '.')
    # Get number of commas to determine how many protein blocks we can do
    number_of_commas=`head -n1 $name.ang| tr -cd , | wc -c`
    # Alternatively, it is possible to do following lines to get number of aas to determine how many protein blocks we can do
    # number_of_aa=`cat $name.seq | wc -c`
    # number_of_aa=$((number_of_aa-3))

    # Change five by three because the two last Amino acids are missing with five. For example, for protein 1A3C, with j-5 last Amino acids are I, Y and E, N are missing. If we correct with 3 last amino acids are E and N.
    number_of_commas=$((number_of_commas-4))

    for((num=1;num<=$number_of_commas;num++));do
        head -n1 $name.ang | cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.ang
        tail -n1 $name.ang | cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.ang
        cat $name.seq | cut -c$num-$((num+4)) > ./protein_blocks/$name.$num.seq
    done
done
