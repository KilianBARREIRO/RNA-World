codonTable <- list(
  "Phenylalanine" = c("UUU", "UUC"),
  "Leucine" = c("UUA", "UUG", "CUU", "CUC", "CUA", "CUG"),
  "Isoleucine" = c("AUU", "AUC", "AUA"),
  "Methionine (Start)" = c("AUG"),
  "Valine" = c("GUU", "GUC", "GUA", "GUG"),
  "Serine" = c("UCU", "UCC", "UCA", "UCG", "AGU", "AGC"),
  "Proline" = c("CCU", "CCC", "CCA", "CCG"),
  "Threonine" = c("ACU", "ACC", "ACA", "ACG"),
  "Alanine" = c("GCU", "GCC", "GCA", "GCG"),
  "Tyrosine" = c("UAU", "UAC"),
  "Histidine" = c("CAU", "CAC"),
  "Glutamine" = c("CAA", "CAG"),
  "Asparagine" = c("AAU", "AAC"),
  "Lysine" = c("AAA", "AAG"),
  "Aspartic Acid" = c("GAU", "GAC"),
  "Glutamic Acid" = c("GAA", "GAG"),
  "Cysteine" = c("UGU", "UGC"),
  "Tryptophan" = c("UGG"),
  "Arginine" = c("CGU", "CGC", "CGA", "CGG", "AGA", "AGG"),
  "Glycine" = c("GGU", "GGC", "GGA", "GGG"),
  "Stop" = c("UAA", "UAG", "UGA")
)

mtData <- MeltingTemperature(codonTable)
