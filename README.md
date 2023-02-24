# TFM
Detection of long non-coding RNAs (lncRNAs) during Spaceflight using RNA-seq data

- using mouse datasets from [NASA GeneLab](https://genelab.nasa.gov) database
- with Ensembl/GENCODE annotations
- to study multi-organ, multi-tissue lncRNA alterations

## Running the analysis

The first worflow downloads all the raw data

```
snakemake -c1 --use-conda --jobs 1 --config subsample='true' subreads=10000 -s Snakefile_download --cluster 'sbatch --partition eck-q'
```


The second workflow unzips fastq.gz raw data

```
snakemake -c1 --use-conda --jobs 1 -s Snakefile_decompress --cluster 'sbatch --partition eck-q'
```

Now create config tables:
```
python data_to_config.py
```

The third workflow run STAR-DESeq2

```
snakemake ...
```

## other
worflow to Trim paired-end reads with trimmomatic

```
snakemake -c1 --rerun-incomplete --use-conda --jobs 1 -s Snakefile_trimmomatic --cluster 'sbatch --partition eck-q'
```
