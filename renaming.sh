#!/bin/bash

# Define the input directory, output directory, and chromosome renaming file
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"
vcf_dir="$TRIMMED_BASE_DIR/vcf/vcf_norm"
rename_file="$TRIMMED_BASE_DIR/newname.txt"

# Loop over all normalized VCF files in the directory
for vcf_file in ${vcf_dir}/barcode*.norm.vcf.gz; do
  # Extract the base name without the extension
  base_name=$(basename "$vcf_file" .norm.vcf.gz)

  # Define the output file name
  output_file="${vcf_dir}/${base_name}.renamed.vcf.gz"

  # Rename chromosomes in the VCF file using bcftools
  echo "Renaming chromosomes in $vcf_file using $rename_file"
  bcftools annotate --rename-chrs "$rename_file" -Oz -o "$output_file" "$vcf_file"

  echo "Renamed VCF saved to $output_file"
done
