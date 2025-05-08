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

all_aa <- names(codonTable)
no_stop <- names(codonTable)[-21]

mtData <- MeltingTemperature(codonTable) %>% 
  select(AminoAcid, MeanTm) %>%
  distinct(AminoAcid, .keep_all = TRUE)

mtDistributionData_Boxplot <- MeltingTemperature(codonTable) %>%
  ggplot(aes(x = AminoAcid, y = MeltTemp)) +
        geom_boxplot() +
        theme_minimal() +
        coord_flip()

aa_base_df <- lapply(names(codonTable), function(aa) {
  codons <- codonTable[[aa]]
  
  gc_content <- sapply(codons, function(codon) {
    str_count(codon, "[GC]") / 3
  })
  
  au_content <- sapply(codons, function(codon) {
    str_count(codon, "[AU]") / 3
  })
  
  data.frame(
    AminoAcid = aa,
    GC_content = mean(gc_content),
    AU_content = mean(au_content)
  )
}) %>% bind_rows()

# codon_gc_weighted <- function(codon) {
#   bases <- strsplit(codon, "")[[1]]
#   score <- sum(bases[1:2] %in% c("G", "C")) * 0.4 + 
#     sum(bases[3] %in% c("G", "C")) * 0.2
#   return(score) # Max possible = 1.0
# }
# 
# codon_au_weighted <- function(codon) {
#   bases <- strsplit(codon, "")[[1]]
#   score <- sum(bases[1:2] %in% c("A", "U")) * 0.4 + 
#     sum(bases[3] %in% c("A", "U")) * 0.2
#   return(score) # Max possible = 1.0
}


