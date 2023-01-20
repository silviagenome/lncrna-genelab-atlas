
rule all:
    input:
        corrected=expand(config['output_path']+"/data/{accession}/{accession}-{genes_or_transcripts}s-corrected-{metric}s",accession=config["accession"],genes_or_transcripts=ANNOT_OBJECTS, metric=METRICS)

        
        
config['accession']

rule download_data:
    input:
    
    envs:
        "envs/genelab-utils.yaml"
    output:
        "data/lncRNA_GLDS-168.fastq"
        
    shell:
        #"conda activate genelab-utils"
