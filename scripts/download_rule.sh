#!/bin/bash


myosd_id=($1)
mysamples=($2)
for ((i=0;i<${#mysamples[@]};i++)); do
GL-download-GLDS-data -g ${myosd_id[i]} -f --pattern ${mysamples[i]}
done
