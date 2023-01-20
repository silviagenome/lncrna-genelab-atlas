import  

def get_fastq_to_download(raw_file.txt):
    """Return fast files to download in rule download_data."""

def get_osd_id(raw_file.txt)

rule all:
    input: raw_.txt
        # call get_fastq_to_download()
        #corrected=expand(config['output_path']+"/data/{accession}/{accession}-{genes_or_transcripts}s-corrected-{metric}s",accession=config["accession"],genes_or_transcripts=ANNOT_OBJECTS, metric=METRICS)

rule download_data:
    envs:
        "envs/genelab-utils.yaml"
    log: "example.log"
    output: get_fastq_to_download()
    params:
        # OSD-168
        osd_id=get_osd_id()
      
    shell:
        """
        # get one file, no ask for confirmation
        GL-download-GLDS-data -g {params.osd_id} -f --pattern {output}
        """


rule qc_trimmomatic:
    """
    El objetivo qui es tomar un fastq hacer qc
    """    
    
rule download_reference_genome:
    """
    El objetivo qui es descargar genoma (.fasta) y nnotacion de raton (.gtf)
    Dos opcnes:
    - Ensembl
    - GENCODE
    (investigar cual es mejor para lncRNAs)
    """        

rule kallisto_run:
    """
    El objetivo qui es alinear el fastq_filtrado con el genome y referencia de raton
    https://pachterlab.github.io/kallisto/manual
    
    kallisto index [arguments] FASTA-files
    kallisto quant... 
    """       
  
run deseq2:
    
    
   
