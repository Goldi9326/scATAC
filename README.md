# 🧬 scATAC-seq Pipeline (10x Genomics – Cell Ranger ATAC)

Automated Bash pipeline for processing **single-cell ATAC-seq (scATAC-seq)** data using **Cell Ranger ATAC**.

This script performs:

- ✅ Software validation  
- ✅ Reference genome validation  
- ✅ FASTQ validation  
- ✅ Automatic CPU detection  
- ✅ Automatic memory detection  
- ✅ Safe re-run prevention  
- ✅ Complete scATAC processing  

---

## 📌 Overview

This pipeline processes 10x Genomics scATAC-seq FASTQ files and generates:


It uses:

- Cell Ranger ATAC v2.2.0
- GRCh38 (or GRCh38+mm10) reference
- Linux environment

---

## 📂 Project Structure

scATAC_seq/
├── run_scatac.sh
├── data/ # FASTQ files
├── cellranger-atac-2.2.0/ # Cell Ranger software
├── refdata-cellranger-arc-GRCh38-*/ # Reference genome
└── hgmm5k_output/ # Output (generated after run)
---

## 🛠 Requirements

### System
- Linux (Ubuntu recommended)
- ≥ 16 GB RAM (64+ recommended)
- Multi-core CPU

### Software
- Cell Ranger ATAC v2.2.0
- Prebuilt 10x reference genome

---

## 📥 Reference Genome

Download example reference:

```bash
wget -c https://cf.10xgenomics.com/supp/cell-arc/refdata-cellranger-arc-GRCh38-2024-A.tar.gz
tar -xzvf refdata-cellranger-arc-GRCh38-2024-A.tar.gz


Usage

Make script executable:chmod +x run_scatac.sh
##Run Pipeline
./run_scatac.sh

##Script Features

Automatically detects CPU cores

Automatically detects system memory

Validates required directories

Prevents accidental overwrite

Runs full cellranger-atac count


##Output
hgmm5k_output/
Important files:

web_summary.html → Interactive QC report

fragments.tsv.gz → Fragment file

filtered_peak_bc_matrix/ → Accessibility matrix

peaks.bed → Called peaks

possorted_bam.bam → Aligned reads

# scATAC-seq Analysis Pipeline

This repository contains downstream analysis of single-cell ATAC-seq (10x Genomics Cell Ranger ATAC output) using Signac and Seurat.

---

## 📊 Analysis Includes

### 1️⃣ Quality Control
- TSS enrichment calculation
- Nucleosome signal assessment
- Filtering low-quality cells

### 2️⃣ Dimensionality Reduction
- TF-IDF normalization
- LSI (Latent Semantic Indexing)
- UMAP visualization

### 3️⃣ Clustering
- Graph-based clustering
- UMAP high-separation visualization

### 4️⃣ Gene Activity Analysis
- Gene activity matrix computation
- Identification of cluster-specific genes
- Export of:
  - `cluster_gene_markers.csv`
  - `top10_genes_per_cluster.csv`

---

## 📁 Files Included

| File | Description |
|------|------------|
| Scatac.R | Full R analysis script |
| UMAP_high_separation.png | Final cluster visualization |
| cluster_gene_markers.csv | All marker genes per cluster |
| top10_genes_per_cluster.csv | Top 10 genes per cluster |

---

## 🧬 How Cluster-Specific Genes Were Identified

Cluster-specific genes were determined using:

```R
markers <- FindAllMarkers(pbmc, only.pos = TRUE)
