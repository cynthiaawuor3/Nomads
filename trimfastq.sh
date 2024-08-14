#!/bin/bash

# Set the base directory where your barcode directories are located
BASE_DIR="./"

# Set the output base directory where the trimmed files will be saved
OUTPUT_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"

# Create the main trimmed output directory
mkdir -p "$OUTPUT_BASE_DIR"

# Loop through each barcode directory
for BARCODE_DIR in "$BASE_DIR"/barcode*; do
  # Check if it's a directory
  if [ -d "$BARCODE_DIR" ]; then
    # Extract the barcode name (e.g., "barcode01")
    BARCODE_NAME=$(basename "$BARCODE_DIR")
    
    echo "Processing barcode directory: $BARCODE_NAME"
    
    # Create a subdirectory for the barcode inside the trimmed output directory
    BARCODE_OUTPUT_DIR="$OUTPUT_BASE_DIR/$BARCODE_NAME"
    mkdir -p "$BARCODE_OUTPUT_DIR"
    
    # Loop through each FASTQ file in the current barcode directory
    for FASTQ_FILE in "$BARCODE_DIR"/*.fastq.gz; do
      # Extract the base name of the FASTQ file (e.g., "FAZ32935_pass_barcode01_b86dbc88_a53fcf1d_112")
      FASTQ_BASENAME=$(basename "$FASTQ_FILE" .fastq.gz)
      
      echo "  Trimming file: $FASTQ_BASENAME.fastq.gz"
      
      # Run the NanoFilt command and save the output
      gunzip -c "$FASTQ_FILE" | NanoFilt -q 12 -l 300 --headcrop 100 | gzip > "$BARCODE_OUTPUT_DIR/${FASTQ_BASENAME}_nanofilt.fastq.gz"
      
      echo "  Finished trimming: ${FASTQ_BASENAME}_nanofilt.fastq.gz"
    done
    
    echo "Completed processing barcode directory: $BARCODE_NAME"
  fi
done

echo "All barcode directories processed."#!/bin/bash

# Set the base directory where your barcode directories are located
BASE_DIR="./"

# Set the output base directory where the trimmed files will be saved
OUTPUT_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass"

# Loop through each barcode directory
for BARCODE_DIR in "$BASE_DIR"/barcode*; do
  # Check if it's a directory
  if [ -d "$BARCODE_DIR" ]; then
    # Extract the barcode name (e.g., "barcode01")
    BARCODE_NAME=$(basename "$BARCODE_DIR")
    
    # Create an output directory for the trimmed files
    OUTPUT_DIR="$OUTPUT_BASE_DIR/$BARCODE_NAME/trimmed"
    mkdir -p "$OUTPUT_DIR"
    
    # Loop through each FASTQ file in the current barcode directory
    for FASTQ_FILE in "$BARCODE_DIR"/*.fastq.gz; do
      # Extract the base name of the FASTQ file (e.g., "FAZ32935_pass_barcode01_b86dbc88_a53fcf1d_112")
      FASTQ_BASENAME=$(basename "$FASTQ_FILE" .fastq.gz)
      
      # Run the NanoFilt command and save the output
      gunzip -c "$FASTQ_FILE" | NanoFilt -q 12 -l 300 --headcrop 100 | gzip > "$OUTPUT_DIR/${FASTQ_BASENAME}_nanofilt.fastq.gz"
    done
  fi
done
