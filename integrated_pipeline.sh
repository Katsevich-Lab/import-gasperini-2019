# #!/bin/bash

# ============================================
# Unified Pipeline for BAM → FASTQ → Cell Ranger
# Supports pilot and at_scale data
# Handles run1 / run2 structure under at_scale
# Cleans up FASTQ and raw folders after processing
# ============================================

# ----------- Configuration -----------
REFDATA_DIR="${LOCAL_YAO_2023_DATA_DIR}raw/refdata-gex-GRCh38-2020-A"  
MAIN_DIR=$LOCAL_GASPERINI_2019_SRA_DATA_DIR                      # <=== UPDATE this
RAW_DIR="${LOCAL_GASPERINI_2019_SRA_DATA_DIR}raw/" 
PROCESSED_DIR="${LOCAL_GASPERINI_2019_SRA_DATA_DIR}processed/" 
RAW_AT_SCALE_DIR="${RAW_DIR}at_scale/"
RAW_PILOT_DIR="${RAW_DIR}pilot/"
PROCESSED_AT_SCALE="${PROCESSED_DIR}at_scale/"
PROCESSED_PILOT="${PROCESSED_DIR}pilot/"
mkdir -p "$RAW_DIR" \
         "$PROCESSED_DIR" \
         "$RAW_AT_SCALE_DIR" \
         "$RAW_PILOT_DIR" \
         "$PROCESSED_AT_SCALE" \
         "$PROCESSED_PILOT"

# ----------- Main Processing Function -----------
process_srr () {
  local i=$1
  local SRR_ID=$2
  local BAM_URL=$3
  local RAW_SUBDIR=$4
  local PROCESSED_SUBDIR=$5
  local RUN_TAG=$6

  local RAW_DIR="${RAW_SUBDIR}${SRR_ID}/"
  local FASTQ_DIR="${RAW_DIR}fastqs/"
  local OUTPUT_DIR="${PROCESSED_SUBDIR}/${RUN_TAG}/${SRR_ID}/"

  if [ -d "$OUTPUT_DIR" ]; then
    echo "Skipping ${SRR_ID} (already exists under ${RUN_TAG})"
    return
  fi

  echo ">>> Processing ${SRR_ID} into ${RUN_TAG}"

  # Step 1: Download + Convert
  mkdir -p "$RAW_DIR"
  cd "$RAW_DIR" || exit
  wget -O bam.bam "$BAM_URL"
  cellranger bamtofastq --nthreads=8 bam.bam "$FASTQ_DIR"
  mv "$FASTQ_DIR"/*/* "$FASTQ_DIR"
  rmdir "$FASTQ_DIR"/*/ 2>/dev/null || true
  rm bam.bam

  # Step 2: Cell Ranger Count
  mkdir -p "${PROCESSED_SUBDIR}/${RUN_TAG}/"
  cellranger count --id="$SRR_ID" \
                   --transcriptome="$REFDATA_DIR" \
                   --fastqs="$FASTQ_DIR" \
                   --sample="bamtofastq" \
                   --create-bam=true \
                   --output-dir="$OUTPUT_DIR"

  # Step 3: Cleanup
  echo "Cleaning up raw files for ${SRR_ID}"
  rm -r ${RAW_SUBDIR}${SRR_ID}
}

# ============================================
# AT-SCALE: RUN1
# ============================================

for i in {1..1}; do
  SRR_ID="SRR$((i+7967493))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run1"
done

for i in {2..2}; do
  SRR_ID="SRR$((i+7967503))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run1"
done

for i in {3..3}; do
  SRR_ID="SRR$((i+7967513))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run1"
done

for i in {4..8}; do
  SRR_ID="SRR$((i+7967516))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run1"
done

for i in {1..1}; do
  SRR_ID="SRR$((i+7967524))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1B_${i}_SI_GA_F$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run1"
done

for i in {2..8}; do
  SRR_ID="SRR$((i+7967493))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1B_${i}_SI_GA_F$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run1"
done

# ============================================
# AT-SCALE: RUN2
# ============================================

# -------- 2A: i = 1 to 3 --------
for i in {1..3}; do
  SRR_ID="SRR$((i+7967501))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.2A_${i}_SI_GA_G$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run2"
done

# -------- 2A: i = 4 to 8 --------
for i in {4..8}; do
  SRR_ID="SRR$((i+7967502))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.2A_${i}_SI_GA_G$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run2"
done

# -------- 2B: i = 1 to 5 --------
for i in {1..5}; do
  SRR_ID="SRR$((i+7967510))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.2B_${i}_SI_GA_H$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run2"
done

# -------- 2B: i = 6 to 8 --------
for i in {6..8}; do
  SRR_ID="SRR$((i+7967511))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.2B_${i}_SI_GA_H$((i+1)).bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_AT_SCALE_DIR" "$PROCESSED_AT_SCALE" "run2"
done

# ============================================
# PILOT DATASET
# ============================================

for i in {1..6}; do
  SRR_ID="SRR$((i+7967481))"
  BAM_URL="https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/pilot_highmoi_screen.${i}_SI_GA_G${i}.bam.1"
  process_srr "$i" "$SRR_ID" "$BAM_URL" "$RAW_PILOT_DIR" "$PROCESSED_PILOT" "pilot"
done

echo "All samples processed successfully!"

#!/bin/bash

# # Step 1.1: Create directories
# MAIN_DIR="/home/mnt/weka/scratch/yihuihe/gasperini/"
# mkdir -p "$MAIN_DIR"
# cd "$MAIN_DIR"

# RAW_DIR="${MAIN_DIR}raw/"
# mkdir -p "$RAW_DIR"
# cd "$RAW_DIR"

# # Step 1.2: Download fastq files for at-scale datasets
# AT_SCALE_DIR="${RAW_DIR}at_scale/"
# mkdir -p "$AT_SCALE_DIR"
# cd "$AT_SCALE_DIR"

# # Run 1

# for i in {1..1}; do
#   SRR_ID="SRR$((i+7967493))"
#   mkdir -p "$AT_SCALE_DIR${SRR_ID}/"
#   cd "$AT_SCALE_DIR${SRR_ID}/"
#   wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
#   cellranger bamtofastq \
#   --nthreads=8 \
#   bam.bam \
#   "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# mv "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# rmdir "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/
# rm "${AT_SCALE_DIR}${SRR_ID}/bam.bam"
# done

# for i in {2..2}; do
#   SRR_ID="SRR$((i+7967503))"
#   mkdir -p "$AT_SCALE_DIR${SRR_ID}/"
#   cd "$AT_SCALE_DIR${SRR_ID}/"
#   wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
#   cellranger bamtofastq \
#   --nthreads=8 \
#   bam.bam \
#   "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# mv "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# rmdir "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/
# rm "${AT_SCALE_DIR}${SRR_ID}/bam.bam"
# done

# for i in {3..3}; do
#   SRR_ID="SRR$((i+7967513))"
#   mkdir -p "$AT_SCALE_DIR${SRR_ID}/"
#   cd "$AT_SCALE_DIR${SRR_ID}/"
#   wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
#   cellranger bamtofastq \
#   --nthreads=8 \
#   bam.bam \
#   "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# mv "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# rmdir "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/
# rm "${AT_SCALE_DIR}${SRR_ID}/bam.bam"
# done

# for i in {4..8}; do
#   SRR_ID="SRR$((i+7967516))"
#     mkdir -p "$AT_SCALE_DIR${SRR_ID}/"
#   cd "$AT_SCALE_DIR${SRR_ID}/"
#   wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1A_${i}_SI_GA_E$((i+1)).bam.1"
#     cellranger bamtofastq \
#   --nthreads=8 \
#   bam.bam \
#   "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# mv "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# rmdir "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/
# rm "${AT_SCALE_DIR}${SRR_ID}/bam.bam"
# done

# for i in {1..1}; do
#   SRR_ID="SRR$((i+7967524))"
#     mkdir -p "$AT_SCALE_DIR${SRR_ID}/"
#   cd "$AT_SCALE_DIR${SRR_ID}/"
#   wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1B_${i}_SI_GA_F$((i+1)).bam.1"
#     cellranger bamtofastq \
#   --nthreads=8 \
#   bam.bam \
#   "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# mv "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# rmdir "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/
# rm "${AT_SCALE_DIR}${SRR_ID}/bam.bam"
# done

# for i in {2..8}; do
#   SRR_ID="SRR$((i+7967493))"
#     mkdir -p "$AT_SCALE_DIR${SRR_ID}/"
#   cd "$AT_SCALE_DIR${SRR_ID}/"
#   wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/at_scale_screen.1B_${i}_SI_GA_F$((i+1)).bam.1"
#     cellranger bamtofastq \
#   --nthreads=8 \
#   bam.bam \
#   "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# mv "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/* "${AT_SCALE_DIR}${SRR_ID}/fastqs/"
# rmdir "${AT_SCALE_DIR}${SRR_ID}/fastqs"/*/
# rm "${AT_SCALE_DIR}${SRR_ID}/bam.bam"
# done

# # Run 2

# umirelation.rds



# # Step 1.3: Download fastq files for pilot datasets
# PILOT_DIR="${RAW_DIR}pilot/"
# mkdir -p "$PILOT_DIR"
# cd "$PILOT_DIR"

# # for i in {1..6}; do
# #     cd "$PILOT_DIR"
# #     SRR_ID="SRR$((i+7967481))"
# #     mkdir -p "${PILOT_DIR}${SRR_ID}/"
# #     cd "$PILOT_DIR${SRR_ID}/"
# #     wget -O bam.bam "https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/pilot_highmoi_screen.${i}_SI_GA_G${i}.bam.1"
# #     cellranger bamtofastq \
# #     --nthreads=8 \
# #     bam.bam \
# #     "${PILOT_DIR}${SRR_ID}/fastqs/"
# #     mv "${PILOT_DIR}${SRR_ID}/fastqs"/*/* "${PILOT_DIR}${SRR_ID}/fastqs/"
# #     rmdir "${PILOT_DIR}${SRR_ID}/fastqs"/*/
# #     rm "${PILOT_DIR}${SRR_ID}/bam.bam"
# # done

# echo "Download Successfully"


# # Step 2: Create processed directory
# PROCESSED_DIR="${MAIN_DIR}processed/"
# mkdir -p "$PROCESSED_DIR"
# cd "$PROCESSED_DIR"

# REFDATA_DIR="/home/mnt/weka/yihuihe/code/NovaSeq6000_PBMC/refdata-gex-GRCh38-2020-A/"

# # # Step 2.1: Run Cell Ranger count for at-scale datasets
# AT_SCALE_PROCESSED="${PROCESSED_DIR}at_scale/"
# mkdir -p "$AT_SCALE_PROCESSED"
# cd "$AT_SCALE_PROCESSED"


# mkdir -p "${AT_SCALE_PROCESSED}run1/"
# cd "${AT_SCALE_PROCESSED}run1/"

# for i in {1..1}; do
#   SRR_ID="SRR$((i+7967493))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done

# for i in {2..2}; do
#   SRR_ID="SRR$((i+7967503))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done

# for i in {3..3}; do
#   SRR_ID="SRR$((i+7967513))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done

# for i in {5..8}; do
#   SRR_ID="SRR$((i+7967516))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done

# for i in {1..1}; do
#   SRR_ID="SRR$((i+7967524))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done

# for i in {7..8}; do
#   SRR_ID="SRR$((i+7967493))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
#     rm -r "${AT_SCALE_DIR}${SRR_ID}/"
# done

# mkdir -p "${AT_SCALE_PROCESSED}run2/"
# cd "${AT_SCALE_PROCESSED}run2/"

# for i in {1..3}; do
#   SRR_ID="SRR$((i+7967501))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done

# for i in {4..8}; do
#   SRR_ID="SRR$((i+7967502))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done

# for i in {1..5}; do
#   SRR_ID="SRR$((i+7967510))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done
# for i in {6..8}; do
#   SRR_ID="SRR$((i+7967511))"
#   cellranger count --id="${SRR_ID}" \
#                   --transcriptome="$REFDATA_DIR" \
#                   --fastqs="${AT_SCALE_DIR}${SRR_ID}/fastqs/" \
#                   --sample="bamtofastq" \
#                   --create-bam=true
# done



# # # Step 2.2: Run Cell Ranger count for pilot datasets
# PILOT_PROCESSED="${PROCESSED_DIR}pilot/"
# mkdir -p "$PILOT_PROCESSED"
# cd "$PILOT_PROCESSED"
# for i in {1..6}; do
#   SRR_ID="SRR$((i+7967481))"
#     cellranger count --id="${SRR_ID}" \
#                     --transcriptome="$REFDATA_DIR" \
#                     --fastqs="${PILOT_DIR}${SRR_ID}/fastqs/" \
#                     --sample="bamtofastq" \
#                     --create-bam=true
# done

# echo "All tasks completed successfully!"

