#!/bin/bash
# Working directory
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"

# Reference genome path
REFERENCE_GENOME_ORIG="/home/cynthia/Desktop/vectorbase/67/VectorBase-67_AgambiaePEST_Genome.fasta"
# Create a softlink to the working directory
REFERENCE_GENOME_LINK="$TRIMMED_BASE_DIR/VectorBase-67_AgambiaePEST_Genome.fasta"
ln -sf "$REFERENCE_GENOME_ORIG" "$REFERENCE_GENOME_LINK"

# OUTPUT Directories path
SAM_DIR="$TRIMMED_BASE_DIR/sam_files"
BAM_DIR="$TRIMMED_BASE_DIR/bam_files"
SORTED_BAM_DIR="$TRIMMED_BASE_DIR/sorted_bam_files"
SUMMARY_DIR="$TRIMMED_BASE_DIR/summary_files"

# Create the output directories
mkdir -p "$SAM_DIR" "$BAM_DIR" "$SORTED_BAM_DIR" "$SUMMARY_DIR"

# LOOP TO ALIGN,CONVERT SAM TO BAM, GET SUMMARY STATISTICS AND SORT THE BAM FILE
for BARCODE_DIR in "$TRIMMED_BASE_DIR"/barcode*; do
  if [ -d "$BARCODE_DIR" ]; then
    BARCODE_NAME=$(basename "$BARCODE_DIR")
    
    minimap2 -ax map-ont "$REFERENCE_GENOME_LINK" "$BARCODE_DIR"/*.fastq.gz > "$SAM_DIR/$BARCODE_NAME.sam"
    samtools view -S -b "$SAM_DIR/$BARCODE_NAME.sam" > "$BAM_DIR/$BARCODE_NAME.bam"
    samtools flagstat "$BAM_DIR/$BARCODE_NAME.bam" > "$SUMMARY_DIR/$BARCODE_NAME.summary.txt"    
    samtools sort "$BAM_DIR/$BARCODE_NAME.bam" -o "$SORTED_BAM_DIR/$BARCODE_NAME.sorted.bam"
    samtools index "$SORTED_BAM_DIR/$BARCODE_NAME.sorted.bam"
    
    echo "Completed processing for $BARCODE_NAME"# HELP MONITOR THE LOOP 
  fi
done
