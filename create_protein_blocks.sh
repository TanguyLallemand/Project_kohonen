#!/bin/bash
mkdir -p ./protein_blocks
for i in `ls *.ang`; do
    # Get name of PDB
    name=$(basename $i)
    name=$(echo "$name" | cut -f 1 -d '.')
    # Get number of commas to determine how many protein blocks we can do
    number_of_commas=`head -n1 $name.ang| tr -cd , | wc -c`
    # Change five by three because the two last Amino acids are missing with five. For example, for protein 1A3C, with j-5 last Amino acids are I, Y and E, N are missing. If we correct with 3 last amino acids are E and N.
    number_of_commas=$((number_of_commas-3))
    echo $number_of_commas
    for((num=1;num<=$number_of_commas;num++));do
        head -n1 $name.ang| cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.ang.csv
        tail -n1 $name.ang| cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.ang.csv
    done


    # Get number of commas to determine how many protein blocks we can do
    number_of_aa=`cat $name.seq | wc -c`
    echo $number_of_aa
    # Change five by three because the two last Amino acids are missing with five. For example, for protein 1A3C, with j-5 last Amino acids are I, Y and E, N are missing. If we correct with 3 last amino acids are E and N.
    number_of_aa=$((number_of_aa-3))
    for((num=1;num<=$number_of_aa;num++));do
        head -n1 $name.ang| cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.seq.csv
        tail -n1 $name.ang| cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.seq.csv
    done
done
