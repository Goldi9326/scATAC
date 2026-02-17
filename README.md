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
