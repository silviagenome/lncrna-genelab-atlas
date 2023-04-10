#!/bin/bash


myosd_id=($1)
mysamples=($2)
for ((i=0;i<${#mysamples[@]};i++)); do
echo ${mysamples[i]}
GL-download-GLDS-data -g ${myosd_id[i]} -f --pattern ${mysamples[i]}
wait
mv ./${mysamples[i]} -t rawReads/
done
