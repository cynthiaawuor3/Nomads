#!/bin/bash
BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"
# Directory containing annotated VCF files
VCF_DIR="$BASE_DIR/annotated_vcfs"

# Output directory for barcoded VCF files
OUTPUT_DIR="$BASE_DIR/annotated_vcfs/barcoded_vcf"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Loop through each .annotated.vcf file in the directory
for VCF_FILE in $VCF_DIR/*.annotated.vcf; do
    # Extract the base name of the file without the extension
    BASE_NAME=$(basename "$VCF_FILE" .annotated.vcf)
    
    # Define the barcode ID (assuming the barcode is in the base name)
    BARCODE_ID="$BASE_NAME"
    
    # Define the output file name
    OUTPUT_FILE="$OUTPUT_DIR/${BASE_NAME}.annotated.vcf"
    
    # Run bcftools annotate command
    bcftools annotate --set-id "$BARCODE_ID" "$VCF_FILE" > "$OUTPUT_FILE"
    
    # Optionally, print the progress
    echo "Processed $VCF_FILE -> $OUTPUT_FILE"
done
