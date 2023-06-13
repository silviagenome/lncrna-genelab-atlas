library(biomaRt)
library(dplyr)
library(clusterProfiler)
library(org.Mm.eg.db)


# Crear una función para obtener los genes en el rango especificado
get_genes_in_range <- function(ens_ids, distance) {
  # Cargar el objeto Mart
  ensembl <- useMart("ENSEMBL_MART_ENSEMBL", dataset = "mmusculus_gene_ensembl", host = "asia.ensembl.org")
  
  # Obtener información de los genes de interés en una sola consulta
  info <- getBM(attributes = c("ensembl_gene_id", "external_gene_name", "chromosome_name", "start_position", "end_position", "strand"),
                filters = "ensembl_gene_id",
                values = ens_ids,
                mart = ensembl)
  
  # Calcular posiciones de inicio y finalización considerando la distancia
  info$start_position <- info$start_position - distance
  info$end_position <- info$end_position + distance
  
  # Obtener los genes en el rango especificado
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

genes_in_range <- c()

# Cargar la tabla TSV
tabla <- read.table("/home/alumno15/TFM/results-keep-lnc/lncrna-Ensembl-Genes-109-spaceflight-vs-control.diffexp-1-168.tsv", sep="\t", header=TRUE)
tabla_verificacion <- read.table("/home/alumno15/TFM/results-tablas/spaceflight-vs-control.diffexp-1-168.tsv", sep="\t", header=TRUE)


# Filtrar genes según los criterios especificados
ens_ids <- tabla$ensembl_gene_id[tabla$padj < 0.05 & (tabla$log2FoldChange > 1 | tabla$log2FoldChange < -1)]


# Obtener los genes en el rango especificado
distance <- 100000
genes_in_range <- get_genes_in_range(ens_ids, distance)

# Filtrar los genes de genes_in_range que aparecen en tabla_verificacion
genes_finales <- genes_in_range[genes_in_range %in% tabla_verificacion$gene]

# Filtrar la tabla_verificacion según las condiciones requeridas
tabla_verificacion_filtrada <- tabla_verificacion[tabla_verificacion$padj < 0.05 &
                                       (tabla_verificacion$log2FoldChange > 1 | tabla_verificacion$log2FoldChange < -1), ]

# Obtener la lista de genes en genes_in_range que se encuentran en la tabla filtrada
genes_finales <- intersect(genes_in_range, tabla_verificacion_filtrada$gene)

##GO ENRICHMENT##
enrich_result <- enrichGO(gene          = genes_finales,
                          OrgDb         = org.Mm.eg.db,  # Base de datos específica para Mus musculus
                          keyType       = "ENSEMBL",
                          ont           = "BP",          # Ontología biológica de procesos (BP)
                          pvalueCutoff = 0.05,          # Umbral de significancia para el valor de p
                          qvalueCutoff = 0.05,
                          pAdjustMethod = "BH")          # Umbral de significancia para el q-value ajustado

# Imprimir los resultados de enriquecimiento de GO
print(enrich_result)

####GRÁFICOS####

# Realizar análisis de enriquecimiento funcional

library(enrichplot)
barplot(enrich_result, showCategory=20) + labs(x = "Genes Count", y = "GO term")
dotplot(enrich_result, showCategory=30) + labs(y = "GO term")
