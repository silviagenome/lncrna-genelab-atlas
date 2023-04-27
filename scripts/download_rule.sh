#!/bin/bash


myosd_id=($1)
mysamples=($2)
for ((i=0;i<${#mysamples[@]};i++)); do
echo ${mysamples[i]}
sample=${mysamples[i]#rawReads/}
GL-download-GLDS-data -g ${myosd_id[i]} -f --pattern ${sample}
wait
mv ./${mysamples[i]} -t rawReads/
done
