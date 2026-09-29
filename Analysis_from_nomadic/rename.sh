#!/bin/bash

CSV="/home/cynthia/Analysis_from_nomadic/STEPHENSI/metadata/stephensi_metadata_final.csv"
FASTQ_DIR="/home/cynthia/NOMADS/BMC/Stephensi"

tail -n +2 "$CSV" | while IFS=',' read -r sample_id barcode
do
    sample_id=$(echo "$sample_id" | xargs | tr -d '\r')
    barcode=$(echo "$barcode" | xargs | tr -d '\r')

    old_file="$FASTQ_DIR/combined.${barcode}.fastq"
    new_file="$FASTQ_DIR/${sample_id}.fastq"

    if [ -f "$old_file" ]; then
        mv "$old_file" "$new_file"
        echo "Renamed: combined.${barcode}.fastq -> ${sample_id}.fastq"
    else
        echo "WARNING: File not found: $old_file"
    fi
done
