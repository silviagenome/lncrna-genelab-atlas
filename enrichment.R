library(biomaRt)

search_protein_coding_genes <- function(ens_id, distance, tabla_verificacion) {
  ensembl <- useMart("ENSEMBL_MART_ENSEMBL", dataset = "mmusculus_gene_ensembl")
  
  # Verificar si se utiliza ENS id o external_gene_name
  if (grepl("^ENSMUS", ens_id)) {
    query_filter <- "ensembl_gene_id"
  } else {
    query_filter <- "external_gene_name"
  }
  
  # Obtener información del gen de interés
  info <- getBM(attributes = c("chromosome_name", "start_position", "end_position", "strand"),
                filters = query_filter,
                values = ens_id,
                mart = ensembl)
  
  # Verificar si se encontró información para el gen
  if (nrow(info) == 0) {
    cat("No se encontró información para el gen especificado.")
    return()
  }
  
  # Calcular posiciones de inicio y finalización considerando la distancia
  start_position <- info$start_position - distance
  end_position <- info$end_position + distance
  
  # Realizar la consulta a BioMart
  result <- getBM(attributes = c("ensembl_gene_id", "external_gene_name", "chromosome_name", "start_position", "end_position", "strand"),
                  filters = c("chromosome_name", "start", "end", "biotype"),
                  values = list(info$chromosome_name, start_position, end_position, "protein_coding"),
                  mart = ensembl)
  
  # Imprimir los resultados
  for (i in 1:nrow(result)) {
    ensembl_gene_id <- result[i, "ensembl_gene_id"]
    external_gene_name <- result[i, "external_gene_name"]
    chromosome_name <- result[i, "chromosome_name"]
    start_position <- result[i, "start_position"]
    end_position <- result[i, "end_position"]
    strand <- result[i, "strand"]
    
    # Verificar si los valores existen y no son nulos
    cat("Ensembl Gene ID:", ensembl_gene_id, "\n")
    cat("External Gene Name:", external_gene_name, "\n")
    cat("Chromosome Name:", chromosome_name, "\n")
    cat("Start Position:", start_position, "\n")
    cat("End Position:", end_position, "\n")
    cat("Strand:", strand, "\n")
    cat(rep("-", 50), "\n")
    
    # Verificar si external_gene_name existe en la tabla inicial
    if (tryCatch(exists("ensembl_gene_id"), error = function(e) FALSE) && length(ensembl_gene_id) > 0) {
      if (tryCatch(!is.na(ensembl_gene_id), error = function(e) FALSE)) {
        if (ensembl_gene_id %in% tabla_verificacion$gene) {
          gene_found <- paste(ensembl_gene_id, "encontrado en la tabla para", ens_id)
        } else {
          gene_found <- paste(ensembl_gene_id, "no encontrado en la tabla para", ens_id)
        }
      } else {
        gene_found <- paste(ensembl_gene_id, "no encontrado en la tabla para", ens_id)
      }
    } else {
      gene_found <- paste("Ensembl Gene ID no encontrado en la tabla para", ens_id)
    }
    
    
    cat(gene_found, "\n")
    cat(rep("-", 50), "\n")
    
    # Agregar el gen encontrado a la lista
    gene_list[[ens_id]] <- gene_found
  }
}




# Cargar la tabla TSV
tabla <- read.table("lncrna-Ensembl-Genes-109-spaceflight-vs-control.diffexp-1-168.tsv", sep="\t", header=TRUE)
tabla_verificacion <- read.table("spaceflight-vs-control.diffexp.tsv", sep="\t", header=TRUE)

# Obtener los valores de Ensembl Gene ID de la tabla
ens_ids <- tabla$ensembl_gene_id
distance <- 10000

options(timeout = 120)

# Crear una lista vacía para almacenar los genes encontrados
gene_list <- list()

# Ejecutar la función con cada valor de Ensembl Gene ID
for (ens_id in ens_ids) {
  search_protein_coding_genes(ens_id, distance, tabla_verificacion)
}

print(gene_list)