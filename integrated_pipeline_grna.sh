#!/bin/bash
cellranger count --help

# Step 1.1: Create directories
MAIN_DIR="/home/mnt/weka/scratch/yihuihe/gasperini/"
mkdir -p "$MAIN_DIR"
OUTPUT_DIR="/home/mnt/weka/scratch/yihuihe/data/external/gasperini-2019-sra/processed/formal/"
mkdir -p "$OUTPUT_DIR"

RAW_DIR="${MAIN_DIR}raw/"
mkdir -p "$RAW_DIR"
PROCESSED_DIR="${MAIN_DIR}processed/"
mkdir -p "$PROCESSED_DIR"

# REF_TRANSCRIPTOME="/home/mnt/weka/yihuihe/code/import-gasperini-2019/grna_dummy_ref/grna_dummy_ref/"
REFDATA_DIR="/home/mnt/weka/yihuihe/code/NovaSeq6000_PBMC/refdata-gex-GRCh38-2020-A/"
REF_GRNA="/home/mnt/weka/yihuihe/code/import-gasperini-2019/GSE120861_grna_groups.at_scale.csv"
LIBRARY_FILE="/home/mnt/weka/yihuihe/code/import-gasperini-2019/libraries.csv"

# Step 1.2: Download fastq files for at-scale datasets
AT_SCALE_DIR="${RAW_DIR}at_scale/"
mkdir -p "$AT_SCALE_DIR"

AT_SCALE_PROCESSED="${PROCESSED_DIR}at_scale/"
mkdir -p "$AT_SCALE_PROCESSED"
mkdir -p "${AT_SCALE_PROCESSED}run1/"
mkdir -p "${AT_SCALE_PROCESSED}run2/"

mkdir -p "${OUTPUT_DIR}at_scale/run1/"
mkdir -p "${OUTPUT_DIR}at_scale/run2/"

# # Run 1
list_1A=("CAGCTAGC" "CTAAGCCT" "CGTTACCG" "GACTGGAC" "GCAAGACC" "TCAATCTC" "ATACCTCG" "TAGAGGCG")
# 1A
for i in {1..1}; do
  SRR_ID_1="SRR$((i+7967493))"
  SRR_ID_2="SRR$((i+7967493+32))"

  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1A_${i}_gRNA_${list_1A[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1A_${i}_gRNA_${list_1A[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run1/"
  cellranger count --id="1A_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run1/1A_${i}/" "${OUTPUT_DIR}at_scale/run1/"
done

for i in {2..2}; do
  SRR_ID_1="SRR$((i+7967503))"
  SRR_ID_2="SRR$((i+7967503+32))"
  
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1A_${i}_gRNA_${list_1A[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1A_${i}_gRNA_${list_1A[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run1/"
  cellranger count --id="1A_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run1/1A_${i}/" "${OUTPUT_DIR}at_scale/run1/"
done

for i in {3..3}; do
  SRR_ID_1="SRR$((i+7967513))"
  SRR_ID_2="SRR$((i+7967513+32))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1A_${i}_gRNA_${list_1A[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1A_${i}_gRNA_${list_1A[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run1/"
  cellranger count --id="1A_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run1/1A_${i}/" "${OUTPUT_DIR}at_scale/run1/"
done

for i in {4..8}; do
  SRR_ID_1="SRR$((i+7967516))"
  SRR_ID_2="SRR$((i+7967516+32))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1A_${i}_gRNA_${list_1A[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1A_${i}_gRNA_${list_1A[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run1/"
  cellranger count --id="1A_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run1/1A_${i}/" "${OUTPUT_DIR}at_scale/run1/"
done

#1B
list_1B=("TAGGTAAC" "TTCGAATA" "TGGACGAC" "GTAGGCTG" "GGTTATCG" "GCATCGTA" "AATACGAT" "TTCCGTCG")
for i in {1..1}; do
  SRR_ID_1="SRR$((i+7967524))"
  SRR_ID_2="SRR$((i+7967524+32))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.1B_${i}_SI_GA_F$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1B_${i}_gRNA_${list_1B[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1B_${i}_gRNA_${list_1B[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run1/"
  cellranger count --id="1B_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run1/1B_${i}/" "${OUTPUT_DIR}at_scale/run1/"
done

for i in {2..8}; do
  SRR_ID="SRR$((i+7967493))"
  SRR_ID_2="SRR$((i+7967493+32))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.1B_${i}_SI_GA_F$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1B_${i}_gRNA_${list_1B[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.1B_${i}_gRNA_${list_1B[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run1/"
  cellranger count --id="1B_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run1/1B_${i}/" "${OUTPUT_DIR}at_scale/run1/"
done

# Run 2

# 2A
list_2A=("AAGTAGCT" "TATTGCTG" "CCAGATAC" "AACGAATT" "CGCTTATC" "AAGTACGC" "GATCTTCG" "TCTTAGCC")
for i in {1..3}; do
  SRR_ID_1="SRR$((i+7967501))"
  SRR_ID_2="SRR$((i+7967501+32))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.2A_${i}_SI_GA_G$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.2A_${i}_gRNA_${list_2A[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.2A_${i}_gRNA_${list_2A[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run2/"
  cellranger count --id="2A_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run2/2A_${i}/" "${OUTPUT_DIR}at_scale/run2/"
done

for i in {4..8}; do
  SRR_ID_1="SRR$((i+7967502))"
  SRR_ID_2="SRR$((i+7967502+32))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.2A_${i}_SI_GA_G$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.2A_${i}_gRNA_${list_2A[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.2A_${i}_gRNA_${list_2A[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run2/"
  cellranger count --id="2A_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run2/2A_${i}/" "${OUTPUT_DIR}at_scale/run2/"
done

# 2B
list_2B=("TTATTGAG" "TTGCGAGC" "GCTTGAAG" "AGTCCGCT" "ACGGCGTT" "GGCTTACT" "GCGCGTTC" "GAGCGCGA")
for i in {1..5}; do
  SRR_ID_1="SRR$((i+7967510))"
  SRR_ID_2="SRR$((i+7967510+32))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.2B_${i}_SI_GA_H$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.2B_${i}_gRNA_${list_2B[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.2B_${i}_gRNA_${list_2B[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run2/"
  cellranger count --id="2B_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run2/2B_${i}/" "${OUTPUT_DIR}at_scale/run2/"
done

for i in {6..8}; do
  SRR_ID_1="SRR$((i+7967511))"
  SRR_ID_2="SRR$((i+7967511+32))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$AT_SCALE_DIR${SRR_ID_1}/"
  cd "$AT_SCALE_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/at_scale_screen.2B_${i}_SI_GA_H$((i+1)).bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_1}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$AT_SCALE_DIR${SRR_ID_2}/"
  cd "$AT_SCALE_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.2B_${i}_gRNA_${list_2B[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/at_scale_screen.2B_${i}_gRNA_${list_2B[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  mv "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${AT_SCALE_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${AT_SCALE_DIR}${SRR_ID_2}/bam.bam"
  echo "${AT_SCALE_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${AT_SCALE_PROCESSED}run2/"
  cellranger count --id="2B_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$AT_SCALE_DIR${SRR_ID_1}/fastqs/"
  rm -r "$AT_SCALE_DIR${SRR_ID_2}/fastqs/"
  cp -r "${AT_SCALE_PROCESSED}run2/2B_${i}/" "${OUTPUT_DIR}at_scale/run2/"
done




# Step 1.3: Download fastq files for pilot datasets
PILOT_DIR="${RAW_DIR}pilot/"
mkdir -p "$PILOT_DIR"
PILOT_PROCESSED="${PROCESSED_DIR}pilot/"
mkdir -p "$PILOT_PROCESSED"
mkdir -p "${OUTPUT_DIR}pilot/"

list_pilot=("CGTTACCG" "ACTATTCA" "GACTGGAC" "TTGCTTAG" "AACGAATT" "TCTATCGC")

for i in {1..6}; do
  SRR_ID_1="SRR$((i+7967481))"
  SRR_ID_2="SRR$((i+7967481+6))"
  echo "fastqs,sample,library_type" > "$LIBRARY_FILE" 

  mkdir -p "$PILOT_DIR${SRR_ID_1}/"
  cd "$PILOT_DIR${SRR_ID_1}/"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_1}/pilot_highmoi_screen.${i}_SI_GA_G${i}.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${PILOT_DIR}${SRR_ID_1}/fastqs/"
  mv "${PILOT_DIR}${SRR_ID_1}/fastqs"/*/* "${PILOT_DIR}${SRR_ID_1}/fastqs/"
  rmdir "${PILOT_DIR}${SRR_ID_1}/fastqs"/*/
  rm "${PILOT_DIR}${SRR_ID_1}/bam.bam"
  echo "${PILOT_DIR}${SRR_ID_1}/fastqs/,bamtofastq,Gene Expression" >> "$LIBRARY_FILE"

  mkdir -p "$PILOT_DIR${SRR_ID_2}/"
  cd "$PILOT_DIR${SRR_ID_2}/"
  echo "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/pilot_highmoi_screen.${i}_${list_pilot[$((i-1))]}.grna.bam.1"
  wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID_2}/pilot_highmoi_screen.${i}_${list_pilot[$((i-1))]}.grna.bam.1"
  cellranger bamtofastq \
  --nthreads=8 \
  bam.bam \
  "${PILOT_DIR}${SRR_ID_2}/fastqs/"
  mv "${PILOT_DIR}${SRR_ID_2}/fastqs"/*/* "${PILOT_DIR}${SRR_ID_2}/fastqs/"
  rmdir "${PILOT_DIR}${SRR_ID_2}/fastqs"/*/
  rm "${PILOT_DIR}${SRR_ID_2}/bam.bam"
  echo "${PILOT_DIR}${SRR_ID_2}/fastqs/,bamtofastq,CRISPR Guide Capture" >> "$LIBRARY_FILE"

  cd "${PILOT_PROCESSED}run2/"
  cellranger count --id="1_${i}" \
  --transcriptome="${REFDATA_DIR}" \
  --create-bam=false \
  --libraries="${LIBRARY_FILE}" \
  --feature-ref="${REF_GRNA}" 

  rm -r "$PILOT_DIR${SRR_ID_1}/fastqs/"
  rm -r "$PILOT_DIR${SRR_ID_2}/fastqs/"
  cp -r ${PILOT_PROCESSED}pilot/1_${i}/ ${OUTPUT_DIR}pilot/
done
  cp -r ${PILOT_PROCESSED}pilot/1_*/ ${OUTPUT_DIR}pilot/


echo "Download Successfully"

