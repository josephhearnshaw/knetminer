MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10_d:enc] -> (protein_10:Protein)
  - [xref_10_10:xref*0..1] - (protein_10b:Protein)
  - [is_a_10_177_d:is_a] -> (enzyme_177:Enzyme)
RETURN path