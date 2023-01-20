
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
        """
        # get one file, no ask for confirmation
        GL-download-GLDS-data -g OSD-168 -f --pattern GLDS-168_rna_seq_Mmus_C57-6J_LVR_RR1_VIV_noERCC_Rep1_M16_R2_raw.fastq.gz
        """

