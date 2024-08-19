#!/bin/bash

# Define the input directory, output directory, and reference genome
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"

# Set the path to the original reference genome file
ref_genome="/home/cynthia/Desktop/vectorbase/67/VectorBase-67_AgambiaePEST_Genome.fasta"
vcf_dir="$TRIMMED_BASE_DIR/vcf"

# Loop over all VCF files in the directory
for vcf_file in ${vcf_dir}/barcode_*.vcf.gz; do
  # Extract the base name without the extension
  base_name=$(basename "$vcf_file" .vcf.gz)

  # Define the output file name
  output_file="${vcf_dir}/${base_name}.normalized.vcf"

  # Normalize the VCF file using bcftools with the reference genome
  echo "Normalizing $vcf_file with reference genome $ref_genome"
  bcftools norm -f "$ref_genome" -o "$output_file" "$vcf_file"

  echo "Normalized VCF saved to $output_file"
done
