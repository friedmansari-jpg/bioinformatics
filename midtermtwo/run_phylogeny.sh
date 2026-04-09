#!/bin/bash

# Run RAxML-NG phylogenetic analysis
raxml-ng \
  --all \
  --msa metazoa_alignment.5k.fasta \
  --model GTR+G \
  --bs-trees 100 \
  --threads 2 \
  --prefix metazoa_tree
