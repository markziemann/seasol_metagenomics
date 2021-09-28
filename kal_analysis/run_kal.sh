#!/bin/bash

for FQZ1 in *_R1.fastq.gz ; do
  FQZ2=$(echo $FQZ1 | sed 's/_R1/_R2/' )
  skewer -q 10 -t 16 $FQZ1 $FQZ2

  FQ1=$(echo $FQZ1 | sed 's/.gz$/-trimmed-pair1.fastq/')
  FQ2=$( echo $FQ1 | sed 's/pair1.fastq/pair2.fastq/' )
  kallisto quant \
  -i ref/GCA_018691715.1_ASM1869171v1_genomic.fna.idx \
  -o ${FQ1}_kal -t 64 $FQ1 $FQ2
  rm $FQ1 $FQ2
done

for TSV in */*abundance.tsv ; do
  NAME=$(echo $TSV | cut -d '_' -f1) ; cut -f1,4 $TSV | sed 1d | sed "s/^/${NAME}\t/"
done > 3col.tsv

for DIR in `ls -d */ | sed 's#/##' ` ; do
  ZIP=$DIR.zip ; zip -r $ZIP $DIR/ &
done
