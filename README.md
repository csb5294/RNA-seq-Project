# RNA-Seq Analysis of POU1F1 Overexpression in HMEC Cells

## Overview

This project demonstrates a computational analysis of RNA-Seq data from human mammary epithelial cells (HMEC). It analyzes two groups of cells, one that overexpresses the transcription factor POU1F1, and a control group. The goal is to identify the differentially expressed genes and to visualize the transcriptional changes using PCA plots, volcano plots, and heatmaps.

## Skills demonstrated:

- RNA-seq data preprocessing and organization

- Differential expression analysis using DESeq2

- Visualization using PCA plot, volcano plot, and heatmap

- Biological interpretation of gene expression patterns

## Data

The dataset was obtained from [GEO: GSE287732](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE287732), containing 6 samples:

| Sample ID  | Condition |
|------------|-----------|
| HMEC_C1    | Control   |
| HMEC_C2    | Control   |
| HMEC_C3    | Control   |
| HMECPIT1_1 | POU1F1    |
| HMECPIT1_2 | POU1F1    |
| HMECPIT1_3 | POU1F1    |

## Methods

1. Data Preprocessing
   - Raw count files were read and merged into a single matrix
   - Metadata for each sample was created for condition labeling
2. Differential Expression Analysis
   - Conducted using DESeq2 in R
   - Genes with FDR < 0.05 and |log2 fold change| > 1 were considered to be significantly differentially expressed
3. Visualization
   - PCA plot: Variance stabilized counts were used to analyze sample clustering
   - Volcano plot: Highlighted significantly up-regulated and down-regulated genes
   - Heatmaps: The top differentially expressed genes showed consistent expression patterns across replicates.

## Results

Figures can be located under results/figures.

#### PCA Plot
The PCA plot showed a clear separation between the control and the POU1F1-overexpressing samples along PC1 (54% variance) and PC2 (29% variance), indicating that POU1F1 leads to clear changes in gene expression.

#### Volcano Plot
The volcano plot identifies 4 significantly differentially expressed genes. Three of these genes were upregulated and one was downregulated indicating potential targets for further investigation.

#### Heatmaps
A heatmap of the 4 genes differentially expressed in the volcano plot were plotted on a heatmap to visualize their clustering between the control and the POU1F1-overexpressing smaples. A separate hehatmap with the top 10 genes was also created and it showed a similar clustering with 3 genes showing downregulation and 7 showing upregulation. This confirms the results from the PCA and Volcano plots and visually demonstrates the differences in expression.

## Conclusion

This project deonstrates a coplete RNA-Seq pipeline from raw counts to visualization. POU1F1 overexpression induces a clear transcriptional signature in HMEC cells as showen by the PCA seaparation, differentially expressed genes, and heatmap patterns. This project highlights skills in computational genomics, statistical analysis, and data visualization suitable for both academic and industry applications.
