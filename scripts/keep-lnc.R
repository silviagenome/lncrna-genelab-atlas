#!/usr/bin/env Rscript

# Rscript --vanilla keep-lnc.R spaceflight-vs-control.diffexp.tsv

args = commandArgs(trailingOnly=TRUE)

if (length(args) != 1) {
  stop("One argument must be supplied (input file)", call.=FALSE)
}

results <- read.csv(args[1],sep="\t")
colnames(results) <- c('ensembl_gene_id','baseMean', 'log2FoldChange','lfcSE' ,'pvalue','padj')


library(biomaRt)

ensembl_version <- listMarts(mart = NULL, host="www.ensembl.org", path="/biomart/martservice",
          port=80, includeHosts = FALSE, archive = FALSE, ssl.verifypeer = TRUE, 
          ensemblRedirect = NULL, verbose = FALSE)$version[1]

ensembl109 <- useMart(host='http://www.ensembl.org',
                     biomart='ENSEMBL_MART_ENSEMBL',
                     dataset='mmusculus_gene_ensembl')

listAttributes(mart = ensembl109)

geneinfo <- getBM(attributes=c('ensembl_gene_id', 'ensembl_gene_id_version',
                               'external_gene_name','gene_biotype',
                               'chromosome_name','start_position','end_position','strand',
                               'source', 'description'
                               ),
                  mart = ensembl109)


df2 <-  merge(x=results, y=geneinfo, by='ensembl_gene_id' )

df3 <- df2[which(df2$gene_biotype=='lncRNA'),]

# save table
write.csv (  df3[order(df3$padj , decreasing= FALSE),] ,  file= paste0('lncrna-', ensembl_version , '-',args[1] ), row.names = FALSE )
