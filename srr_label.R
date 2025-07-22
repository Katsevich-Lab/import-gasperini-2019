## ---------------------------------------
## 1. 构建工具函数用于提取 label
## ---------------------------------------
extract_label_gene <- function(url) {
  # url 例如: "https://.../SRR7967494/at_scale_screen.1A_1_SI_GA_E2.bam.1"
  # 先取 basename:
  fname <- basename(url)  # "at_scale_screen.1A_1_SI_GA_E2.bam.1"
  # 去掉最前面到第一个 '.' 为止:
  part <- sub("^.*?\\.", "", fname)      # "1A_1_SI_GA_E2.bam.1"
  # 再去掉末尾的 ".bam.1"
  label <- sub("\\.bam\\.1$", "", part)  # "1A_1_SI_GA_E2"
  return(label)
}

extract_label_grna <- function(url) {
  # url 例如: "https://.../SRR7967526/at_scale_screen.1A_1_gRNA_CAGCTAGC.grna.bam.1"
  fname <- basename(url)  # "at_scale_screen.1A_1_gRNA_CAGCTAGC.grna.bam.1"
  part <- sub("^.*?\\.", "", fname)        # "1A_1_gRNA_CAGCTAGC.grna.bam.1"
  label <- sub("\\.grna\\.bam\\.1$", "", part)  # "1A_1_gRNA_CAGCTAGC"
  return(label)
}

## 用于构建 https 前缀，固定部分
make_prefix <- function(SRR_ID) {
  # https://sra-pub-src-1.s3.amazonaws.com/${SRR_ID}/
  paste0("https://sra-pub-src-1.s3.amazonaws.com/", SRR_ID, "/")
}

## ---------------------------------------
## 2. 构建 at_scale_srr_label
## ---------------------------------------
# 我们先预定义几个列表，与脚本保持一致
list_1A <- c("CAGCTAGC", "CTAAGCCT", "CGTTACCG", "GACTGGAC", "GCAAGACC", "TCAATCTC", "ATACCTCG", "TAGAGGCG")
list_1B <- c("TAGGTAAC", "TTCGAATA", "TGGACGAC", "GTAGGCTG", "GGTTATCG", "GCATCGTA", "AATACGAT", "TTCCGTCG")
list_2A <- c("AAGTAGCT", "TATTGCTG", "CCAGATAC", "AACGAATT", "CGCTTATC", "AAGTACGC", "GATCTTCG", "TCTTAGCC")
list_2B <- c("TTATTGAG", "TTGCGAGC", "GCTTGAAG", "AGTCCGCT", "ACGGCGTT", "GGCTTACT", "GCGCGTTC", "GAGCGCGA")

# 收集结果
at_scale_res <- list()

## 一个小工具函数：将一行记录 (rowname, gene_label, grna_label) 存入列表
add_row_at_scale <- function(SRR_ID_1, gene_label, grna_label) {
  at_scale_res[[SRR_ID_1]] <<- c(gene_expression_label = gene_label,
                                 grna_enrichment_label = grna_label)
}

#
# ------------------ Run1: 1A ------------------
#

# 1A: for i in {1..1}
for (i in 1:1) {
  SRR_ID_1 <- paste0("SRR", i + 7967493)       # SRR7967494 (i=1)
  SRR_ID_2 <- paste0("SRR", i + 7967493 + 32)  # SRR7967526 (i=1)
  
  # gene expression URL
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.1A_", i, "_SI_GA_E", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  # gRNA URL
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.1A_", i, "_gRNA_", list_1A[i], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

# 1A: for i in {2..2}
for (i in 2:2) {
  SRR_ID_1 <- paste0("SRR", i + 7967503)
  SRR_ID_2 <- paste0("SRR", i + 7967503 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.1A_", i, "_SI_GA_E", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.1A_", i, "_gRNA_", list_1A[i-1], ".grna.bam.1"
    # 注意 i-1，因为 bash 里用的是 ${list_1A[$((i-1))]}
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

# 1A: for i in {3..3}
for (i in 3:3) {
  SRR_ID_1 <- paste0("SRR", i + 7967513)
  SRR_ID_2 <- paste0("SRR", i + 7967513 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.1A_", i, "_SI_GA_E", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.1A_", i, "_gRNA_", list_1A[i-1], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

# 1A: for i in {4..8}
for (i in 4:8) {
  SRR_ID_1 <- paste0("SRR", i + 7967516)
  SRR_ID_2 <- paste0("SRR", i + 7967516 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.1A_", i, "_SI_GA_E", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.1A_", i, "_gRNA_", list_1A[i-1], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

#
# ------------------ Run1: 1B ------------------
#
list_1B <- c("TAGGTAAC", "TTCGAATA", "TGGACGAC", "GTAGGCTG", "GGTTATCG", "GCATCGTA", "AATACGAT", "TTCCGTCG")

# 1B: for i in {1..1}
for (i in 1:1) {
  SRR_ID_1 <- paste0("SRR", i + 7967524)
  SRR_ID_2 <- paste0("SRR", i + 7967524 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.1B_", i, "_SI_GA_F", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.1B_", i, "_gRNA_", list_1B[i], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

# 1B: for i in {2..8}
for (i in 2:8) {
  # 注意原脚本这里变量名有疑似笔误，这里改为 SRR_ID_1 / SRR_ID_2，和上面逻辑保持一致
  SRR_ID_1 <- paste0("SRR", i + 7967493)
  SRR_ID_2 <- paste0("SRR", i + 7967493 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.1B_", i, "_SI_GA_F", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.1B_", i, "_gRNA_", list_1B[i-1], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

#
# ------------------ Run2: 2A ------------------
#
# 2A: for i in {1..3}
for (i in 1:3) {
  SRR_ID_1 <- paste0("SRR", i + 7967501)
  SRR_ID_2 <- paste0("SRR", i + 7967501 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.2A_", i, "_SI_GA_G", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.2A_", i, "_gRNA_", list_2A[i], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

# 2A: for i in {4..8}
for (i in 4:8) {
  SRR_ID_1 <- paste0("SRR", i + 7967502)
  SRR_ID_2 <- paste0("SRR", i + 7967502 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.2A_", i, "_SI_GA_G", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.2A_", i, "_gRNA_", list_2A[i-1], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

#
# ------------------ Run2: 2B ------------------
#
# 2B: for i in {1..5}
for (i in 1:5) {
  SRR_ID_1 <- paste0("SRR", i + 7967510)
  SRR_ID_2 <- paste0("SRR", i + 7967510 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.2B_", i, "_SI_GA_H", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.2B_", i, "_gRNA_", list_2B[i], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

# 2B: for i in {6..8}
for (i in 6:8) {
  SRR_ID_1 <- paste0("SRR", i + 7967511)
  SRR_ID_2 <- paste0("SRR", i + 7967511 + 32)
  
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "at_scale_screen.2B_", i, "_SI_GA_H", i+1, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "at_scale_screen.2B_", i, "_gRNA_", list_2B[i-1], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_at_scale(SRR_ID_1, gene_label, grna_label)
}

# 将收集的列表转成矩阵
at_scale_mat <- do.call(rbind, at_scale_res)
rownames(at_scale_mat) <- names(at_scale_res)
colnames(at_scale_mat) <- c("gene_expression_label", "grna_enrichment_label")

## ---------------------------------------
## 3. 构建 pilot_srr_label
## ---------------------------------------
pilot_list <- c("CGTTACCG", "ACTATTCA", "GACTGGAC", "TTGCTTAG", "AACGAATT", "TCTATCGC")

pilot_res <- list()

add_row_pilot <- function(SRR_ID_1, gene_label, grna_label) {
  pilot_res[[SRR_ID_1]] <<- c(gene_expression_label = gene_label,
                              grna_enrichment_label = grna_label)
}

# 对应脚本 Step1.3: for i in {1..6}
for (i in 1:6) {
  SRR_ID_1 <- paste0("SRR", i + 7967481)        # e.g. i=1 -> "SRR7967482"
  SRR_ID_2 <- paste0("SRR", i + 7967481 + 6)    # e.g. i=1 -> "SRR7967488"
  
  # gene expression
  ge_url <- paste0(
    make_prefix(SRR_ID_1),
    "pilot_highmoi_screen.", i, "_SI_GA_G", i, ".bam.1"
  )
  gene_label <- extract_label_gene(ge_url)
  
  # grna
  grna_url <- paste0(
    make_prefix(SRR_ID_2),
    "pilot_highmoi_screen.", i, "_", pilot_list[i], ".grna.bam.1"
  )
  grna_label <- extract_label_grna(grna_url)
  
  add_row_pilot(SRR_ID_1, gene_label, grna_label)
}

pilot_mat <- do.call(rbind, pilot_res)
rownames(pilot_mat) <- names(pilot_res)
colnames(pilot_mat) <- c("gene_expression_label", "grna_enrichment_label")

## ---------------------------------------
## 4. 存储到同一个 RDS 文件
## ---------------------------------------
srr_label <- list(
  at_scale_srr_label = at_scale_mat,
  pilot_srr_label    = pilot_mat
)
print(at_scale_mat)
print(pilot_mat)
saveRDS(srr_label, file = "srr_label.rds")
cat("完成！已将 at_scale_srr_label 和 pilot_srr_label 两个矩阵存储到 srr_label.rds。\n")
