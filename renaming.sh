#!/bin/bash
##THIS SCRIPT IS ONLY USED IF YOUR VCF FILE CHROMOSOME LABEL SLIGHTLY DIFFER FROM THE SNPEFF DATABASE CHROMOSOME
#input directory 
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"
#output directory
vcf_dir="$TRIMMED_BASE_DIR/vcf/vcf_norm"
#chromosome renaming file i.e if AgamP43R change to 3R
rename_file="$TRIMMED_BASE_DIR/newname.txt"

# renaming the vcf file to match the chromosome labelling in snpeff
for vcf_file in ${vcf_dir}/barcode*.norm.vcf.gz; do
  base_name=$(basename "$vcf_file" .norm.vcf.gz)
  output_file="${vcf_dir}/${base_name}.renamed.vcf.gz"
  bcftools annotate --rename-chrs "$rename_file" -Oz -o "$output_file" "$vcf_file"
done
