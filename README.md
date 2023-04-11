# Analysis of long non-coding RNAs (lncRNAs) during Spaceflight

- using mouse RNA-seq datasets from [NASA GeneLab](https://genelab.nasa.gov) database
- with Ensembl 109 annotations
- to study multi-organ, multi-tissue lncRNA alterations

## Running the analysis

The first worflow downloads all the raw data

```
snakemake -c1 --use-conda --jobs 1 --config subsample='true' subreads=10000 -s Snakefile_download --cluster 'sbatch --partition eck-q'
```


The second workflow trimmes to Trim paired-end reads with trimmomatic

```
snakemake -c1 --use-conda --jobs 1 -s Snakefile_trimmomatic --cluster 'sbatch --partition eck-q'
```

Now create config tables:
```
python data_to_config.py
```

The third workflow run STAR-DESeq2

```
snakemake -c24 -F --use-conda --jobs 24 -s Snakefile --latency-wait 60 --cluster 'sbatch --partition eck-q'
```

Generation of the report

```
snakemake --report report.zip
```


