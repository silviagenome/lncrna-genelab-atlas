#!/bin/bash

myosd_id=($1)
mysamples=($2)
subsamplefastq=$3
subsamplereads=$4

for ((i=0;i<${#mysamples[@]};i++)); do
  GL-download-GLDS-data -g ${myosd_id[i]} -f --pattern ${mysamples[i]}
  
  if [ $subsamplefastq == 'true']; then
  
    mv ${mysamples[i]} temp.fq.gz
    
    gunzip temp.fq.gz
    
    seqtk sample -s 123 temp.fq $subsamplereads > sub_temp.fq
    
    rm temp.fq
    
    gzip sub_temp.fq
    
    mv sub_temp.fq.gz ${mysamples[i]}
    
    rm sub_temp.fq.gz
  
  fi
  
done
