#!/bin/bash
BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"


# Vcf directory for barcoded VCF files
VCF_DIR="$BASE_DIR/annotated_vcfs/barcoded_vcf"

# Output file name
OUTPUT_FILE="$BASE_DIR/annotated_vcfs/barcoded_vcf/Ag_no_filter.txt"

# Find the first VCF file to extract the header
FIRST_VCF=$(find "$VCF_DIR" -name "*.vcf" | head -n 1)

# Write the header of the first VCF file to the output file
grep '^#' "$FIRST_VCF" > "$OUTPUT_FILE"

# Append the content of each VCF file (excluding headers) to the output file
for VCF_FILE in "$VCF_DIR"/*.vcf; do
    grep -v '^#' "$VCF_FILE" >> "$OUTPUT_FILE"
done

# Optionally, print a completion message
echo "All VCF files have been merged into $OUTPUT_FILE"
