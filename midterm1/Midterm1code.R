# Midterm 1

# Q1: Import and align DNA sequences

# Download packages needed
install.packages("BiocManager")
install.packages(c("ape","seqinr"))             
BiocManager::install(c("Biostrings","msa"))

library(Biostrings)
library(msa)

# Set working directory
setwd("C:/Users/fried/OneDrive/Documents/GitHub/bioinformatics/midterm1")
getwd()

# Read sequences
DNA <- readDNAStringSet("sequences.fasta")
DNA

length(DNA)

# Align using ClustalW in msa package
alignment <- msa(DNA, method = "ClustalW")
alignment

aligned <- DNAStringSet(as.character(alignment))
width(aligned)




# Q2: How good is alignment?

# Distance matrix for similarity/quality
library(ape)

alignedDNA <- as.DNAbin(as.matrix(aligned))
distance <- dist.dna(alignedDNA, model = "raw")
distance

# Average distance per sample
dist_matrix <- as.matrix(distance)
avg_distance <- rowMeans(dist_matrix)
avg_distance

# Most samples have average distance of about 0.00078
# The highest distance was Homo_sapiens_6 with 0.0106 (outlier)
# Because all distances are very small, this shows that the sequences are highly similar and the alignment is also good.




# Q3: Consensus sequence

# Align characters
aligned_char <- as.character(aligned)

# Remove gaps
aligned_char_nogap <- gsub("-", "", aligned_char)
aligned_nogap <- DNAStringSet(aligned_char_nogap)

# Create consensus sequence
consensus <- consensusString(aligned_nogap)
consensus

# Save as FASTA file
writeXStringSet(DNAStringSet(consensus),"consensus.fasta")




# Q4: GC Content

# Create list of bases
chars <- unlist(strsplit(as.character(aligned), split = ""))

# Remove the gaps
chars <- chars[chars != "-"]

# Count the bases
table(chars)

# Calculating GC %
gc_percent <- (sum(chars == "G" | chars == "C") / length(chars)) * 100
gc_percent

# The GC content of the alignment without gaps is 51.56944%




# Q5: How different are the samples?

# Average distance
sort(avg_distance, decreasing = TRUE)

# Confirm the outlier
outlier_name <- names(avg_distance)[which.max(avg_distance)]
outlier <- aligned[outlier_name]
outlier

# Compared using genetic distance 
# All sequences have a similar average distance except 6
# Homo_sapiens_6 had the biggest average distance and therefore the most different sample

# Then compared Homo_sapiens_6 to Homo_sapiens_1

# Assigned ref to the normal Homo_sapiens_1 and out to Homo_sapiens_6
ref <- as.character(aligned["Homo_sapiens_1"])
out <- as.character(aligned[outlier_name])

# Looked at first 60 bases to visually see gaps/mutations
substring(as.character(ref), 1, 60)
substring(as.character(out), 1, 60)

# Homo_sapiens_6(out) shows a "-" at the beginning which means gap(insertion/deletion)
# There are also differences in bases (SNPs) at some positions

# Calculating total differences
num_differences <- sum(strsplit(ref, "")[[1]] != strsplit(out, "")[[1]])
num_differences

ref_vec <- strsplit(ref, "")[[1]]
out_vec <- strsplit(out, "")[[1]]

# Count gaps + SNPs
num_gaps <- sum(ref_vec == "-" | out_vec == "-")
num_snps <- sum(ref_vec != out_vec & ref_vec != "-" & out_vec != "-")

num_gaps
num_snps

# There are 8 total differences, 1 gap(insertion, deletion, etc) and 7 SNPs



# Q6:BLASTing the sequence

blast_seq <- DNA["Homo_sapiens_1"]
blast_seq

# Save file in working directory
writeXStringSet(blast_seq, "BLASTsequence.fasta")

# Make sure files are there
getwd()
list.files()

# Upload to NCBI BLAST as a nucleotide BLASTn
# Best match was Homo sapiens HBB gene for beta globin
# It showed 100% identity(642/642 bases) and an e-value of 0.0
# Accession number: LC121775.1



# Q7: Translate most different sequence to protein

# Confirm most different sequence
outlier_name <- names(avg_distance)[which.max(avg_distance)]
outlier_name

# Make sure we are using the raw DNA (no gaps)
outlier_DNA <- DNA[outlier_name]
outlier_DNA

# Translate the DNA into protein
outlier_protein <- translate(outlier_DNA)
outlier_protein

# Save file in working directory
writeXStringSet(outlier_protein, "Homo_sapiens_6_protein.fasta")

# Make sure files are there
getwd()
list.files()

# Q8: What protein does it match to?
# Upload to NCBI BLAST as a protein BLASTp
# Best match was Human hemoglobin subunit beta
# It showed 100% identity(30/30 amino acids) and an e-value of 1e-09(very small)
# Accession number: KAI2558340.1



# Q9: What disease is the gene associated with?

# On OMIM, most common diseases were Sickle cell disease and Beta-thalassemia
# These are both disorders that affect hemoglobin and caused by mutations in the HBB gene
# The protein sequence showed 100% identity to normal human HBB
# The protein appears normal and no known disease causing mutation is identified
# This means there isn't evidence of this individual having one of these diseases








