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

# Set the output directories for SAM, BAM, sorted BAM, summary, and VCF files
SAM_DIR="$TRIMMED_BASE_DIR/sam_files"
BAM_DIR="$TRIMMED_BASE_DIR/bam_files"
SORTED_BAM_DIR="$TRIMMED_BASE_DIR/sorted_bam_files"
SUMMARY_DIR="$TRIMMED_BASE_DIR/summary_files"
VCF_DIR="$TRIMMED_BASE_DIR/vcf"

# Create the directories if they do not exist
mkdir -p "$SAM_DIR" "$BAM_DIR" "$SORTED_BAM_DIR" "$SUMMARY_DIR" "$VCF_DIR"

# Loop through all sorted BAM files that start with 'barcode' and end with '.sorted.bam'
for BAM_FILE in "$SORTED_BAM_DIR"/barcode*.sorted.bam; do
    # Extract the barcode number (assuming it's in the format 'barcodeXX')
    BARCODE=$(basename "$BAM_FILE" | sed 's/barcode\([0-9]*\).sorted.bam/\1/')
    
    # Output VCF file for the current barcode
    OUTPUT_VCF="$VCF_DIR/barcode_${BARCODE}.vcf.gz"

    # Generate the VCF file for the current BAM file
    bcftools mpileup -B -f "$REFERENCE_GENOME_LINK" "$BAM_FILE" | bcftools call -vmO z -o "$OUTPUT_VCF"| bcftools index $OUTPUT_VCF
    
    echo "Generated VCF file: $OUTPUT_VCF"
done

echo "All VCF files generated and saved in the $VCF_DIR directory."

