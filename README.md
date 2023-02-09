# TFM
Detection of long non-coding RNAs (lncRNAs) during Spaceflight using RNA-seq data

- using mouse datasets from [NASA GeneLab](https://genelab.nasa.gov) database
- with Ensembl/GENCODE annotations
- to study multi-organ, multi-tissue lncRNA alterations

## Running the analysis

The first worflow downloads all the raw data

```
snakemake --cores 2 --use-conda --config datasets=raw_data.txt  Snakefile_download
```

The second worflow...
