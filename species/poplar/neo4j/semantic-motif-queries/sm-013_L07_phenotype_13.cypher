MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [rel_10_10:h_s_s|ortho*0..1] -> (protein_10b:Protein)
  - [enc_10_9:enc] -> (gene_9:Gene)
  - [rel_9_9_2:genetic|physical*0..2] -> (gene_9b:Gene)
  - [has_observ_pheno_9_13:has_observ_pheno] -> (phenotype_13:Phenotype)
RETURN path