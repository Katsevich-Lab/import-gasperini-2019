#!/bin/bash

# Step 1.1: Create directories
MAIN_DIR="/home/mnt/weka/scratch/yihuihe/gasperini/"
mkdir -p "$MAIN_DIR"
cd "$MAIN_DIR"

RAW_DIR="${MAIN_DIR}raw/"
mkdir -p "$RAW_DIR"
cd "$RAW_DIR"

# Step 1.2: Download fastq files for at-scale datasets
AT_SCALE_DIR="${RAW_DIR}at_scale/"
mkdir -p "$AT_SCALE_DIR"
cd "$AT_SCALE_DIR"

for i in {7967494..7967525}; do
  cd "$AT_SCALE_DIR"
  SRR_ID="SRR$i"
  prefetch "$SRR_ID"
  cd "${AT_SCALE_DIR}${SRR_ID}/"
  fastq-dump --split-files "${SRR_ID}.sra"
  mv "${SRR_ID}_1.fastq" "${SRR_ID}_S1_L001_R1_001.fastq"
  mv "${SRR_ID}_2.fastq" "${SRR_ID}_S1_L001_R2_001.fastq"
done

# Step 1.3: Download fastq files for pilot datasets
PILOT_DIR="${RAW_DIR}pilot/"
mkdir -p "$PILOT_DIR"
cd "$PILOT_DIR"

for i in {7967482..7967487}; do
  cd "$PILOT_DIR"
  SRR_ID="SRR$i"
  prefetch "$SRR_ID"
  cd "${PILOT_DIR}${SRR_ID}/"
  fastq-dump --split-files "${SRR_ID}.sra"
  mv "${SRR_ID}_1.fastq" "${SRR_ID}_S1_L001_R1_001.fastq"
  mv "${SRR_ID}_2.fastq" "${SRR_ID}_S1_L001_R2_001.fastq"
done

echo "Download Successfully"