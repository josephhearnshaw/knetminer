MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [xref_10_10_3:xref*0..3] -> (protein_10b:Protein)
  - [enc_10_9:enc] -> (gene_9:Gene)
  - [rel_9_9_2:genetic|physical*0..2] -> (gene_9b:Gene)
  - [cooc_wi_9_16:cooc_wi] -> (tO_16:TO)
RETURN path