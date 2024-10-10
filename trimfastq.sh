#!/bin/bash
BASE_DIR="./"

#Set output directory
OUTPUT_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"

# Create the trimmed directory
mkdir -p "$OUTPUT_BASE_DIR"

#A Loop for trimming all the barcode reads in their directories
for BARCODE_DIR in "$BASE_DIR"/barcode*; do
  if [ -d "$BARCODE_DIR" ]; then
    BARCODE_NAME=$(basename "$BARCODE_DIR")
    BARCODE_OUTPUT_DIR="$OUTPUT_BASE_DIR/$BARCODE_NAME" #maintain the directory names
    mkdir -p "$BARCODE_OUTPUT_DIR"
    
    for FASTQ_FILE in "$BARCODE_DIR"/*.fastq.gz; do
      FASTQ_BASENAME=$(basename "$FASTQ_FILE" .fastq.gz)
      gunzip -c "$FASTQ_FILE" | NanoFilt -q 12 -l 300 --headcrop 100 | gzip > "$BARCODE_OUTPUT_DIR/${FASTQ_BASENAME}_nanofilt.fastq.gz"
    #-q remove reads with quality below 12,remove reads less than 300 in length(short) and crop the first 100 bases(the base quality are lower in these regions)
    done
  fi
done

