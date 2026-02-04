library(tidyverse)
library(pheatmap)
library(DESeq2)
library(apeglm)

metadata <- read_tsv("data/raw/sample_metadata.tsv")

count_files <- list.files(
  "data/raw/GSE287732_RAW",
  pattern = "featureCounts.tabular$",
  full.names = TRUE
)

count_list <- lapply(count_files, read_tsv)

count_matrix <- count_list %>% 
  purrr::reduce(full_join, by = "Geneid") %>%
  column_to_rownames("Geneid")


colnames(count_matrix) <- metadata$sample_id

head(count_matrix)

dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = metadata,
  design = ~ condition
)

#Filter out low counts 
dds <- dds[rowSums(counts(dds)) > 1, ]

dds <- DESeq(dds)

res <- results(dds)

#Quick look at DESeq2 results table
head(res)

#Filter out genes that are not statistically significant
res_filtered <- res[!is.na(res$padj) & res$padj < 0.05, ]

#Quick look at filtered table
head(res_filtered)

library(EnhancedVolcano)
EnhancedVolcano(
  res,
  lab = rownames(res),
  x = "log2FoldChange",
  xlim = c(-10,10),
  y = "padj",
  ylim = c(0,8),
  pCutoff = 0.05,
  FCcutoff = 1
)

#significant genes
sig <- res %>%
  as.data.frame() %>%
  rownames_to_column("gene") %>%
  filter(padj < 0.05, abs(log2FoldChange) > 1)


#PCA plot
vsd <- vst(dds, blind = TRUE)

pca_plot <- plotPCA(
  vsd,
  intgroup = "condition",
  returnData = FALSE
)


res_tbl <- as.data.frame(res) %>%
  rownames_to_column("gene_id")

#Extract top 4 genes for heatmap
top_genes <- res_tbl %>%
  filter(
    !is.na(padj),
    padj < 0.05,
    abs(log2FoldChange) > 1
  ) %>%
  arrange(padj) %>%
  slice_head(n = 4) %>%
  pull(gene_id)

vsd_mat <- assay(vsd)

heatmap_mat <- vsd_mat[top_genes, ]

#Scale by gene
heatmap_scaled <- t(scale(t(heatmap_mat)))

#Heatmap
pheatmap(
  heatmap_scaled,
  annotation_col = data.frame(
    condition = metadata$condition,
    row.names = metadata$sample_id
  ),
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = FALSE,
  fontsize_col = 10,
  main = "Top Differentially Expressed Genes"
)


#Extract top 10 genes for a bigger picture
top_10_genes <- res_tbl %>%
  filter(
    !is.na(padj),
    padj < 0.1
  ) %>%
  arrange(padj) %>%
  slice_head(n = 10) %>%
  pull(gene_id)

heatmap_mat <- vsd_mat[top_10_genes, ]

heatmap_scaled <- t(scale(t(heatmap_mat)))

#Heatmap for top 10 genes
pheatmap(
  heatmap_scaled,
  annotation_col = data.frame(
    condition = metadata$condition,
    row.names = metadata$sample_id
  ),
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = FALSE,
  fontsize_col = 10,
  main = "Top 10 Differentially Expressed Genes"
)