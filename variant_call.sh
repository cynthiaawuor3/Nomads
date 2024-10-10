#!/bin/bash

# Working directory
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"

#reference genome file
REFERENCE_GENOME_ORIG="/home/cynthia/Desktop/vectorbase/67/VectorBase-67_AgambiaePEST_Genome.fasta"

#Create a softlink for the reference genome in the working directory
REFERENCE_GENOME_LINK="$TRIMMED_BASE_DIR/VectorBase-67_AgambiaePEST_Genome.fasta"
ln -sf "$REFERENCE_GENOME_ORIG" "$REFERENCE_GENOME_LINK"

# Set output directories for SAM, BAM, sorted BAM, summary, and VCF files
SAM_DIR="$TRIMMED_BASE_DIR/sam_files"
BAM_DIR="$TRIMMED_BASE_DIR/bam_files"
SORTED_BAM_DIR="$TRIMMED_BASE_DIR/sorted_bam_files"
SUMMARY_DIR="$TRIMMED_BASE_DIR/summary_files"
VCF_DIR="$TRIMMED_BASE_DIR/vcf"

# Create a VCF directory 
mkdir -p "$VCF_DIR"

# Loop the bam files through variant calling and generate a vcf file
for BAM_FILE in "$SORTED_BAM_DIR"/barcode*.sorted.bam; do
    BARCODE=$(basename "$BAM_FILE" | sed 's/barcode\([0-9]*\).sorted.bam/\1/')

    OUTPUT_VCF="$VCF_DIR/barcode_${BARCODE}.vcf.gz" #output1
    FILTERED_VCF="$VCF_DIR/barcode_${BARCODE}.filtered.vcf.gz" #filteredvcf output2
    # mpileup generates genotype likelihoods at each genomic position with coverage and call do the actual call
    bcftools mpileup -B -I -Q10 -h 100 -f "$REFERENCE_GENOME_LINK" "$BAM_FILE" | bcftools call -mO z -P 0.01 -o "$OUTPUT_VCF"
    bcftools index "$OUTPUT_VCF"
    #use view to filter the vcf file using a bed file with specific regions
    bcftools view -R /home/cynthia/nomadic3/ag-IR.amplicons.multiplex01.bed  -Oz -o "$FILTERED_VCF" "$OUTPUT_VCF"
    bcftools index "$FILTERED_VCF"
done

