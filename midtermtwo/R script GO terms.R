Midterm 2

# Install BioManager if needed
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# Install UniprotR
install.packages("UniprotR")

# Load in UniprotR package
library(UniprotR)

# Set working directory 
setwd("C:/Users/fried/OneDrive/Documents/GitHub/bioinformatics/midtermtwo")

# Get GO data from UniProt
go_data <- GetProteinGOInfo("P54098")
go_data

# Create the GO counts for each section
go_counts <- c(6, 7, 6)

# Label the GO term categories
names(go_counts) <- c("Biological Process", "Molecular Function", "Cellular Component")

# Create pdf for plot to go in
pdf("C:/Users/fried/OneDrive/Documents/GitHub/bioinformatics/midtermtwo/GO_plot.pdf")

# Create bar plot
barplot(go_counts,
        main = "GO categories for POLG",
        ylab = "Number of GO terms")

# Close and save pdf
dev.off()

# Make sure pdf is in correct folder
list.files()
