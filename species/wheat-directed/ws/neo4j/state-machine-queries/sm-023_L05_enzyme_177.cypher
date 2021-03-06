MATCH path = (gene_1:Gene)
  - [enc_1_10_d:enc] -> (protein_10:Protein)
  - [rel_10_10:h_s_s|ortho|xref*0..1] - (protein_10b:Protein)
  - [is_a_10_177_d:is_a] -> (enzyme_177:Enzyme)
WHERE gene_1.iri IN $startGeneIris
RETURN path