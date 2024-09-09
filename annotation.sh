#!/bin/bash
TRIMMED_BASE_DIR="/home/cynthia/NOMADS/2024-08-02_AnGam_CAO/no_sample/20240802_1622_MN30463_FAZ32935_b86dbc88/fastq_pass/trimmed"
# Path to snpEff
SNPEFF_JAR="/home/cynthia/snpEff/snpEff.jar"

# Path to snpEff configuration file
SNPEFF_CONFIG="/home/cynthia/snpEff/snpEff.config"

# Path to reference genome
REFERENCE_GENOME="Anopheles_gambiae"

# Directory containing VCF files
VCF_DIR="$TRIMMED_BASE_DIR/vcf/vcf_norm"
ANNOTATED_DIR="$TRIMMED_BASE_DIR/annotated_vcfs"

mkdir -p "$ANNOTATED_DIR"
# Loop through each .vcf.gz file in the directory
for VCF_FILE in $VCF_DIR/*.renamed.vcf.gz; do
    # Extract the base name of the file without the extension
    BASE_NAME=$(basename "$VCF_FILE" .renamed.vcf.gz)
    
    # Define the output file name
    OUTPUT_FILE="$TRIMMED_BASE_DIR/annotated_vcfs/${BASE_NAME}.annotated.vcf"
    ZIP_FILE="$TRIMMED_BASE_DIR/annotated_vcfs/${BASE_NAME}.annotated.vcf.gz"
    
    # Run snpEff command
    java -jar "$SNPEFF_JAR" ann -noLog -noStats -no-downstream -no-upstream -no-utr -c "$SNPEFF_CONFIG" -o vcf "$REFERENCE_GENOME" "$VCF_FILE" > "$OUTPUT_FILE"
    
    bgzip -c "$OUTPUT_FILE" > "$ZIP_FILE"

    bcftools index  "$ZIP_FILE" 

# Optionally, print the progress
    echo "Annotated $VCF_FILE -> $ZIP_FILE"
done

cd "$ANNOTATED_DIR" 
bcftools merge *.annotated.vcf.gz -Oz -o Ag_merged_variants.vcf.gz
 
