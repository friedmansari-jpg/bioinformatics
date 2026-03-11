# Lab 10

# Q1:

# Set working directory
setwd("C:/Users/fried/OneDrive/Documents/GitHub/bioinformatics/labten")
getwd()

# Install packages needed
# install.packages("BiocManager")
# install.packages("UniprotR")
# install.packages("protti")
# install.packages("r3dmol")

BiocManager::install("GenomicAlignments")

library(Biostrings)
library(UniprotR)
library(protti)
library(r3dmol)




# Q2:

# Lab 6 amino acid seq
aa_seq <- "MVLSPDDKTNVKAAWGKVGAHAGEYGAEALERMFLSFPTTKTYFPHFDLSHGSAQVKGHGKKVADALTNAVAHVDDMPNALSALSDLHAHKLRVDPVNFKLLSHCLLVTLAAHLPAEFTPAVHASLDKFLASVSTVLTSKYRAGASVAMLLAPL"

# Turn into object
aa_set <- AAStringSet(aa_seq)

# Name and write to fasta file
names(aa_set) <- "labsix_protein"
writeXStringSet(aa_set, filepath = "labsix_protein.fasta")

aa_set

# BLAST protein in UniProt
# Save top 5 into txt file




# Q3:

# Read txt file
accessions <- readLines("entries.txt")
accessions




# Q4:

# Format into character string
class(accessions)

# Combine strings
accession_string <- paste(accessions, collapse = ", ")
accession_string



# Q5: 

# Get GO terms
go_info <- GetProteinGOInfo(accessions)

# Look at info
head(go_info)
View(go_info)




# Q6:

# Plot GO terms
PlotGoInfo(go_info)

# Save GO plot
pdf("GOterms_plot.pdf", width = 8, height = 6)
PlotGoInfo(go_info)
dev.off()



# Q7:

# Edit GO plot
PlotGOAll(
  GOObj = go_info,
  Top = 10,
  directorypath = getwd(),
  width = 8,
  height = 5
)




# Q8:

# Biological Processes: inflammatory response, nitric oxide transport, oxygen transport
# Molecular Function: heme binding, iron ion binding, oxygen binding
# Cellular Component: haptoglobin-hemoglobin complex, hemoglobin complex, blood microparticle




# Q9:

# Get pathology info
pathology_info <- GetPathology_Biotech(accessions)
pathology_info

# Get disease info
disease_info <- Get.diseases(pathology_info)
disease_info
View(disease_info)

# Given by the disease run, Alpha-thalassemia (A-THAL) is a genetic blood disorder cause by mutations 
# or deletions in the alpha-globin gene, which disrupts normal hemoglobin production and reduces the blood’s 
# ability to carry oxygen. Another one given by the pathology run was Heinz body anemia, which is a hemolytic 
# anemia caused by unstable hemoglobin that forms inclusions inside your red blood cells.




# Q10:

# Get UniProt and structure info with protti
uniprot_info <- fetch_uniprot(accessions)
View(uniprot_info)
names(uniprot_info)



# Q11:

# Pull structural info from pdbs
pdb_ids <- c("1A00", "1A01")
pdb_info <- fetch_pdb(pdb_ids)
View(pdb_info)



# Q12: 

# Get 3D structure info
af_info <- fetch_alphafold_prediction(accessions)
View(af_info)



