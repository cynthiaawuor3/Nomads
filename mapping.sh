#!/bin/bash

# Set the base directory for the trimmed FASTQ files
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"

# Set the path to the original reference genome file
REFERENCE_GENOME_ORIG="/home/cynthia/Desktop/vectorbase/67/VectorBase-67_AgambiaePEST_Genome.fasta"

# Set the path for the reference genome link in the trimmed directory
REFERENCE_GENOME_LINK="$TRIMMED_BASE_DIR/VectorBase-67_AgambiaePEST_Genome.fasta"

# Create a symbolic link for the reference genome in the trimmed directory
ln -sf "$REFERENCE_GENOME_ORIG" "$REFERENCE_GENOME_LINK"
echo "Created symbolic link for reference genome in trimmed directory."

# Set the output directories for SAM, BAM, sorted BAM, and summary files
SAM_DIR="sam_files"
BAM_DIR="bam_files"
SORTED_BAM_DIR="sorted_bam_files"
SUMMARY_DIR="summary_files"

# Create the output directories if they don't exist
#mkdir -p "$SAM_DIR" "$BAM_DIR" "$SORTED_BAM_DIR" "$SUMMARY_DIR"

# Loop through each barcode directory in the trimmed directory
for BARCODE_DIR in "$TRIMMED_BASE_DIR"/barcode*; do
  # Check if it's a directory
  if [ -d "$BARCODE_DIR" ]; then
    # Extract the barcode name (e.g., "barcode82")
    BARCODE_NAME=$(basename "$BARCODE_DIR")
    
    echo "Processing barcode directory: $BARCODE_NAME"
    
    # Concatenate all FASTQ files in the barcode directory and align them using minimap2
    #minimap2 -ax map-ont "$REFERENCE_GENOME_LINK" "$BARCODE_DIR"/*.fastq.gz > "$SAM_DIR/$BARCODE_NAME.sam"
    echo "  Generated SAM file: $SAM_DIR/$BARCODE_NAME.sam"
    
    # Convert the SAM file to a BAM file
    #samtools view -S -b "$SAM_DIR/$BARCODE_NAME.sam" > "$BAM_DIR/$BARCODE_NAME.bam"
    echo "  Converted to BAM: $BAM_DIR/$BARCODE_NAME.bam"
    
    # Generate flagstat summary for the BAM file
    #samtools flagstat "$BAM_DIR/$BARCODE_NAME.bam" > "$SUMMARY_DIR/$BARCODE_NAME.summary.txt"
    echo "  Generated summary: $SUMMARY_DIR/$BARCODE_NAME.summary.txt"
    
    # Sort the BAM file
    samtools sort "$BAM_DIR/$BARCODE_NAME.bam" -o "$SORTED_BAM_DIR/$BARCODE_NAME.sorted.bam"
    echo "  Sorted BAM file: $SORTED_BAM_DIR/$BARCODE_NAME.sorted.bam"
    
    # Index the sorted BAM file
    samtools index "$SORTED_BAM_DIR/$BARCODE_NAME.sorted.bam"
    echo "  Indexed BAM file: $SORTED_BAM_DIR/$BARCODE_NAME.sorted.bam.bai"
    
    echo "Completed processing for $BARCODE_NAME"
  fi
done

echo "All barcode directories processed."

