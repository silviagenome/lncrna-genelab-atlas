# Analysis of long non-coding RNAs (lncRNAs) during Spaceflight

- using mouse RNA-seq datasets from [NASA GeneLab](https://genelab.nasa.gov) database
- with Ensembl 109 annotations
- to study multi-organ, multi-tissue lncRNA alterations

## Running the analysis

It is necessary to run this first Snakefile of preparation of directories

```
snakemake -c1 --jobs 1 -s Snakefile_pre --cluster 'sbatch --partition eck-q' --latency-wait 60
```

The first worflow downloads all the raw data and trimmes to Trim paired-end reads with trimmomatic

```
snakemake -c32 --use-conda --jobs 32 -s Snakefile_download_trimmomatic --cluster 'sbatch --partition eck-q'
```

Now create config tables:
```
python data_to_config.py
```

The third workflow run STAR-DESeq2, it has to be run from rna-seq-star-deseq2/workflow

```
snakemake -c4 -F --use-conda --jobs 4 -s Snakefile --latency-wait 60 --cluster 'sbatch --partition ledley-q -eo'
```

Generation of the report

```
snakemake --report report.zip
```

For filtering out non-lncRNAs and adding annotations use `./scripts/keep-lnc.R`.


## References

Part of our pipelines uses (with modifications) the workflow https://github.com/snakemake-workflows/rna-seq-star-deseq2
