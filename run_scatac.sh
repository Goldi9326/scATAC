#!/bin/bash

set -e  # Stop on error

########################################
# USER CONFIGURATION (MODIFIED FOR YOU)
########################################

# Adjust this path if reference is somewhere else
REF_DIR="/home/hp/scATAC_seq/refdata-cellranger-arc-GRCh38-2024-A"

FASTQ_DIR="data"
CELLRANGER_DIR="cellranger-atac-2.2.0"

OUTPUT_ID="hgmm5k_output"

# Auto-detect cores (leave 4 free for system stability)
TOTAL_CORES=$(nproc)
CORES=$((TOTAL_CORES - 4))

# Auto-detect memory (in GB)
TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
MEMORY=$((TOTAL_MEM - 8))

########################################
echo "======================================"
echo "     scATAC-seq Pipeline Starting     "
echo "======================================"

echo "Detected cores: $TOTAL_CORES"
echo "Using cores: $CORES"
echo "Detected memory: ${TOTAL_MEM}GB"
echo "Using memory: ${MEMORY}GB"
echo ""

########################################
echo "Step 1: Checking Required Software..."

for tool in cellranger-atac; do
    if [ ! -x "$CELLRANGER_DIR/$tool" ]; then
        echo "ERROR: $tool not found inside $CELLRANGER_DIR"
        exit 1
    fi
done

export PATH=$(pwd)/$CELLRANGER_DIR:$PATH

if ! command -v cellranger-atac &> /dev/null; then
    echo "ERROR: cellranger-atac not accessible."
    exit 1
fi

echo "Cell Ranger ATAC is ready."
echo ""

########################################
echo "Step 2: Checking Reference Genome..."

if [ ! -d "$REF_DIR" ]; then
    echo "ERROR: Reference directory not found at:"
    echo "$REF_DIR"
    exit 1
fi

echo "Reference genome found."
echo ""

########################################
echo "Step 3: Checking FASTQ Files..."

if [ ! -d "$FASTQ_DIR" ]; then
    echo "ERROR: FASTQ directory not found."
    exit 1
fi

FASTQ_COUNT=$(ls $FASTQ_DIR/*.fastq.gz 2>/dev/null | wc -l)

if [ "$FASTQ_COUNT" -eq 0 ]; then
    echo "ERROR: No FASTQ files found in $FASTQ_DIR"
    exit 1
fi

echo "Found $FASTQ_COUNT FASTQ files."
echo ""

########################################
echo "Step 4: Running scATAC Analysis..."

if [ -d "$OUTPUT_ID" ]; then
    echo "Output directory already exists."
    echo "If you want to re-run, delete it:"
    echo "rm -rf $OUTPUT_ID"
    exit 0
fi

cellranger-atac count \
  --id=$OUTPUT_ID \
  --reference="$REF_DIR" \
  --fastqs="$(pwd)/$FASTQ_DIR" \
  --sample=atac_hgmm_5k_nextgem \
  --localcores=$CORES \
  --localmem=$MEMORY

echo ""
echo "======================================"
echo "  Pipeline Completed Successfully!   "
echo "======================================"
echo ""
echo "Check results in:"
echo "$OUTPUT_ID/web_summary.html"
