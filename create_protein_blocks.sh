#!/bin/bash
mkdir -p ./protein_blocks
for i in `ls *.ang`; do
    # Get name of PDB
    name=$(basename $i)
    name=$(echo "$name" | cut -f 1 -d '.')

    number_of_commas=`cat $name.ang| tr -cd , | wc -c`
    j=$((number_of_commas / 2))
    for((num=1;num<=$j;num++));do
        head -n1 $name.ang| cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.csv
        tail -n1 $name.ang| cut -d ',' -f $num-$((num+4)) | paste -s -d ',' >> ./protein_blocks/$name.$num.csv
    done
done
