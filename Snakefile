configfile: "config.yaml"

rule download_data:
    input:
        expand(
        )
    output:
        "data/lncRNA_GLDS-168.fastq"
    shell:
        "conda activate genelab-utils"
    shell:
        "GL-download-GLDS-data -g OSD-168 -f --pattern GLDS-168_rna_seq_Mmus_C57-6J_LVR_RR1_VIV_noERCC_Rep1_M16_R2_raw.fastq.gz"
    shell:
        "gunzip GLDS-168_rna_seq_Mmus_C57-6J_LVR_RR1_VIV_noERCC_Rep1_M16_R2_raw.fastq.gz"

rule quality:
    input:
        "data/lncRNA_GLDS-168.fastq"
    output:
        "data/lncRNA_GLDS-168_quality.fastq"
    tools:
        Trimmomatic

rule alignment:
    input:
        "data/lncRNA_GLDS-168_quality.fastq"
    output:
        "data/lncRNA_GLDS-168_quality_aligned.fastq"
    tools:
        Alignment tools

rule quantification:
    input:
        "data/lncRNA_GLDS-168_quality_aligned.fastq"
    output:
        "data/read_counts.csv"
    tools:
        Quantification tools

rule normalization:
    input:
        "data/lncRNA_GLDS-168_quality_aligned.fastq"
    output:
        "data/lncRNA_GLDS-168_quality_aligned_normalized.fastq"
    tools:
        R library deseq2

rule expression_analysis:
