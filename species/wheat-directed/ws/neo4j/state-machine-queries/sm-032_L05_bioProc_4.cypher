MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10_d:enc] -> (protein_10:Protein)
  - [xref_10_10:xref*0..1] - (protein_10b:Protein)
  - [participates_in_10_4_d:participates_in] -> (bioProc_4:BioProc)
RETURN path