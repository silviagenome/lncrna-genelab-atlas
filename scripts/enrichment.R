library(biomaRt)
library(dplyr)
library(clusterProfiler)
library(org.Mm.eg.db)
library(ggplot2)
library(tidyverse)

#Creating a function to retrieve genes within the specified range
get_genes_in_range <- function(ens_ids, distance) {
  # Loading the Mart object.
  ensembl <- useMart("ENSEMBL_MART_ENSEMBL", dataset = "mmusculus_gene_ensembl", host = "asia.ensembl.org")
  
  # Retrieving information for the genes of interest in a single query.
  info <- getBM(attributes = c("ensembl_gene_id", "external_gene_name", "chromosome_name", "start_position", "end_position", "strand"),
                filters = "ensembl_gene_id",
                values = ens_ids,
                mart = ensembl)
  
  # Calculating start and end positions, taking distance into consideration.
  info$start_position <- info$start_position - distance
  info$end_position <- info$end_position + distance
  
  # Retrieving the genes within the specified range.
  genes_in_range <- character()
  for (i in 1:nrow(info)) {
    genes <- getBM(attributes = "ensembl_gene_id",
                   filters = c("chromosome_name", "start", "end"),
                   values = list(info[i, "chromosome_name"], info[i, "start_position"], info[i, "end_position"]),
                   mart = ensembl)$ensembl_gene_id
    genes_in_range <- c(genes_in_range, genes)
  }

  return(unique(genes_in_range))
}

# loading tsv tables
pathway_lncrna <- ""
pathway_allgenes <- ""

table <- read.table(pathway_lncrna, sep="\t", header=TRUE)
table_verification <- read.table(pathway_allgenes, sep="\t", header=TRUE)

# Filtering of genes based on the specified criteria.
ens_ids_up <- tabla$ensembl_gene_id[tabla$padj < 0.05 & tabla$log2FoldChange > 1]
ens_ids_down <- tabla$ensembl_gene_id[tabla$padj < 0.05 & tabla$log2FoldChange < - 1]

# Obtaining the genes within the specified range.
distance <- 100000
genes_in_range <- c()
genes_in_range <- get_genes_in_range(ens_ids_[up/down], distance)

# Obtaining the list of genes in genes_in_range that are present in the verification table.
final_genes <- intersect(genes_in_range, tabla_verificacion$gene)

##GO ENRICHMENT##

enrich_result <- enrichGO(gene = final_genes,
                          OrgDb = org.Mm.eg.db,  
                          keyType = "ENSEMBL",
                          ont = "ALL",         
                          pvalueCutoff = 0.05,          
                          qvalueCutoff = 0.05,
                          pAdjustMethod = "BH")          

# Printing the results of the GO enrichment.
print(enrich_result)

##GO ENRICHMENT PLOTTING##

enrich_result <- as.data.frame(enrich_result)

enrich_result$`-log10pvalue` <- -10 * log10(enrich_result$pvalue)

enrich_result %>% arrange(across(.cols=c(ONTOLOGY, `-log10pvalue`))) %>%
  group_by(ONTOLOGY) %>%       # Agrupar por ontología
  slice_max(n = 5, order_by = `-log10pvalue`) %>%        # Mantener solo los 5 primeros términos por ontología
  ungroup() %>%               # Desagrupar
  rowid_to_column() %>% 
  ggplot()  +
  geom_bar(aes(y =  reorder(Description, rowid),  x = `-log10pvalue`, fill = ONTOLOGY), stat = "identity",  width = 0.7) +
  scale_fill_manual(values = c("BP" = "#009E73", "CC" = "#D55E00", "MF" = "#CC79A7")) +
  theme_bw() +
  xlab("Enrichment score(-log10p-value)") +
  ylab("GO enrichment terms") +
  theme(legend.title = element_blank(),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16))

##WikiPathways ENRICHMENT##

#Performing the conversion of Ensembl IDs to gene symbols using the org.Mm.eg.db database.
gene_symbols <- bitr(final_genes, fromType = "ENSEMBL", toType = "ENTREZID", OrgDb = org.Mm.eg.db)

enrich_wp <- clusterProfiler::enrichWP(
  gene_symbols$ENTREZID,
  organism = "Mus musculus",
  pAdjustMethod = "BH",
  pvalueCutoff = 0.05, #p.adjust cutoff; relaxed for demo purposes
)

##WikiPathways PLOTTING##

enrich_wp <- as.data.frame(enrich_wp)

enrich_wp$`-log10pvalue` <- -10 * log10(enrich_wp$pvalue)

ggplot(ewp.up, aes(x = `-log10pvalue`, y = Description)) +
  geom_bar(stat = "identity", fill = "#56B4E9") +
  labs(x = "Enrichment score(-log10p-value)", y = "wikiPathways enrichment terms") +
  theme(axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16))
