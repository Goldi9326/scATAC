setwd("/media/hp/One Touch/scATAC_seq_pc/hgmm5k_output/outs")

library(Signac)
library(Seurat)
library(GenomeInfoDb)
library(GenomicRanges)
library(hdf5r)
library(EnsDb.Hsapiens.v86)
library(BSgenome.Hsapiens.UCSC.hg38)
library(ggplot2)

##Load Peak Matrix
counts <- Read10X_h5("filtered_peak_bc_matrix.h5")
head(rownames(counts))

##Add Gene Annotation
annotations <- GetGRangesFromEnsDb(EnsDb.Hsapiens.v86)
seqlevelsStyle(annotations) <- "UCSC"

##Create Chromatin Assay
chrom_assay <- CreateChromatinAssay(
  counts = counts,
  sep = c(":", "-"),
  fragments = "fragments.tsv.gz",
  annotation = annotations,
  min.cells = 10,
  min.features = 200
)

pbmc <- CreateSeuratObject(
  counts = chrom_assay,
  assay = "peaks"
)

##QC Metrics
pbmc <- NucleosomeSignal(pbmc)
pbmc <- TSSEnrichment(pbmc)

VlnPlot(pbmc,
        features = c("nCount_peaks", "TSS.enrichment", "NucleosomeSignal"),
        ncol = 3)
pbmc <- subset(
  pbmc,
  subset = nCount_peaks > 3000 &
    nCount_peaks < 100000 &
    TSS.enrichment > 2 &
    NucleosomeSignal < 4
)

##LSI + Clustering

DefaultAssay(pbmc) <- "peaks"

pbmc <- RunTFIDF(pbmc)
pbmc <- FindTopFeatures(pbmc, min.cutoff = "q0")
pbmc <- RunSVD(pbmc)

pbmc <- RunUMAP(pbmc, reduction = "lsi", dims = 2:30)
pbmc <- FindNeighbors(pbmc, reduction = "lsi", dims = 2:30)
pbmc <- FindClusters(pbmc, resolution = 0.5)
## Check CLustering 
table(pbmc$seurat_clusters)
pbmc <- RunUMAP(
  pbmc,
  reduction = "lsi",
  dims = 3:30,      # skip depth-driven LSI 1
  min.dist = 0.8,   # higher = more separation
  spread = 2        # stretch clusters apart
)

p <- DimPlot(
  pbmc,
  reduction = "umap",
  label = TRUE,
  repel = TRUE,
  pt.size = 0.3
) +
  NoLegend() +
  theme_classic()

print(p)  # display it
##Save PNG
ggsave("UMAP_correct.png", plot = p, width = 8, height = 6, dpi = 600)

Idents(pbmc) <- pbmc$seurat_clusters

##Gene Activity Matrix
gene.activities <- GeneActivity(pbmc)
pbmc[["RNA"]] <- CreateAssayObject(counts = gene.activities)
DefaultAssay(pbmc) <- "RNA"
pbmc <- NormalizeData(pbmc)
pbmc <- ScaleData(pbmc)

##Gene List Per Cluster
Idents(pbmc) <- pbmc$seurat_clusters
markers <- FindAllMarkers(
  pbmc,
  only.pos = TRUE,
  min.pct = 0.1,
  logfc.threshold = 0.25
)

##Export Gene List
write.csv(markers, "cluster_gene_markers.csv")

##Get Top 10 Genes Per Cluster
top10 <- markers %>%
  group_by(cluster) %>%
  top_n(10, avg_log2FC)

write.csv(top10, "top10_genes_per_cluster.csv")


