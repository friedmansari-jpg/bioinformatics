# Download package if needed
if (!requireNamespace("seqinr", quietly = TRUE))
  install.packages("seqinr")

# Load required package
library(seqinr)

# Read alignment
dna <- read.fasta("metazoa_alignment.gene.fasta")

# Look at sequence names
names(dna)

# Extract Homo sapiens DNA sequence
human <- dna[["Homo_sapiens"]]

# Remove gaps from sequence
human_seq <- human[human != "-"]

# Translate DNA to protein
protein <- translate(human_seq)

# Look at protein sequence
protein

# Save protein to FASTA file
write.fasta(
  sequences = list(protein),
  names = "Homo_sapiens_protein",
  file.out = "human_protein.fasta"
)

