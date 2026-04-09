# Load library
library(ape)

# Read tree with bootstrap
tree <- read.tree("metazoa_tree.raxml.support")

# Root the tree
rooted_tree <- root(
  tree,
  outgroup = c("Plakina_jani", "Grantia_compressa"),
  resolve.root = TRUE
)

# Save file
write.tree(rooted_tree, file="metazoa_tree_rooted.nwk")

# Plot rooted tree to PDF
pdf("metazoa_rooted_tree.pdf", width=10, height=12)
plot(rooted_tree, cex=0.6)
dev.off()

# Plot tree with bootstrap
pdf("metazoa_tree_with_support.pdf", width=10, height=12)
plot(tree, cex=0.6)
nodelabels(tree$node.label, cex=0.6, frame="none")
dev.off()
