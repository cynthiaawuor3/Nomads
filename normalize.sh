#!/bin/bash

# Define the directories
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"
vcf_dir="$TRIMMED_BASE_DIR/vcf"
vcf_dir_norm="$TRIMMED_BASE_DIR/vcf/vcf_norm"

mkdir -p "$vcf_dir_norm"
# Loop over all barcode VCF files in the directory
for vcf_file in ${vcf_dir}/barcode_*.filtered.vcf.gz; do
  # Extract the base name without the extension
  base_name=$(basename "$vcf_file" .filtered.vcf.gz)

  # Define the output file name
  output_file="${vcf_dir_norm}/${base_name}.norm.vcf.gz"

  # Normalize the VCF file using bcftools
  echo "Normalizing $vcf_file"
  bcftools norm -m-both -Oz -o "$output_file" "$vcf_file"

  echo "Normalized VCF saved to $output_file"
done

