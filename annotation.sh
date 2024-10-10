#!/bin/bash
# working directory
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"
# snpEff path- create variable for the Jar and config file
SNPEFF_JAR="/home/cynthia/snpEff/snpEff.jar"
SNPEFF_CONFIG="/home/cynthia/snpEff/snpEff.config"
# Reference genome
REFERENCE_GENOME="Anopheles_gambiae"

#  VCF files Directory
VCF_DIR="$TRIMMED_BASE_DIR/vcf/vcf_norm"
# Output directory
ANNOTATED_DIR="$TRIMMED_BASE_DIR/annotated_vcfs"
mkdir -p "$ANNOTATED_DIR"

# Loop through each .vcf.gz file in the directory
for VCF_FILE in $VCF_DIR/*.renamed.vcf.gz; do
    BASE_NAME=$(basename "$VCF_FILE" .renamed.vcf.gz)
    OUTPUT_FILE="$TRIMMED_BASE_DIR/annotated_vcfs/${BASE_NAME}.annotated.vcf"
    ZIP_FILE="$TRIMMED_BASE_DIR/annotated_vcfs/${BASE_NAME}.annotated.vcf.gz"
    # Run snpEff 
    java -jar "$SNPEFF_JAR" ann -noLog -noStats -no-downstream -no-upstream -no-utr -c "$SNPEFF_CONFIG" -o vcf "$REFERENCE_GENOME" "$VCF_FILE" > "$OUTPUT_FILE"
    bgzip -c "$OUTPUT_FILE" > "$ZIP_FILE"
    bcftools index  "$ZIP_FILE" 
done

#Change directory to the annotated files directory and merge all the vcf files for downstream analysis
cd "$ANNOTATED_DIR" 
bcftools merge *.annotated.vcf.gz -Oz -o Ag_merged_variants.vcf.gz
 
