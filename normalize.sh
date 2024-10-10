#!/bin/bash
#AID IN REALIGNMENT OF THE VARIANTS
#Working directory
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"
#input directory
vcf_dir="$TRIMMED_BASE_DIR/vcf"
#output directory
vcf_dir_norm="$TRIMMED_BASE_DIR/vcf/vcf_norm"
mkdir -p "$vcf_dir_norm"

# Normalize all filtered vcf files
for vcf_file in ${vcf_dir}/barcode_*.filtered.vcf.gz; do
  base_name=$(basename "$vcf_file" .filtered.vcf.gz)
  output_file="${vcf_dir_norm}/${base_name}.norm.vcf.gz"
  bcftools norm -m-both -Oz -o "$output_file" "$vcf_file"
done

