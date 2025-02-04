#create sequence ("ACCGCUA")
gen_rna_seq <- function(n) {
  bases <- c("A", "U", "C", "G")
  paste0(sample(bases, n, replace = TRUE), collapse = "")
}

# ("ACC","GUA")
split_into_codons <- function(sequence) {
  codons <- substring(sequence, seq(1, nchar(sequence)-2, by=3), seq(3, nchar(sequence), by=3))
  return(codons)
}

# ("Threonine","Valine")
translate_codon <- function(codon) {
  genetic_code <- list(
    "UUU" = "Phenylalanine", "UUC" = "Phenylalanine", "UUA" = "Leucine", 
    "UUG" = "Leucine", "CUU" = "Leucine", "CUC" = "Leucine", "CUA" = "Leucine", 
    "CUG" = "Leucine", "AUU" = "Isoleucine", "AUC" = "Isoleucine", 
    "AUA" = "Isoleucine", "AUG" = "Methionine (Start)", "GUU" = "Valine", 
    "GUC" = "Valine", "GUA" = "Valine", "GUG" = "Valine", "UCU" = "Serine", 
    "UCC" = "Serine", "UCA" = "Serine", "UCG" = "Serine", "CCU" = "Proline", 
    "CCC" = "Proline", "CCA" = "Proline", "CCG" = "Proline", "ACU" = "Threonine",
    "ACC" = "Threonine", "ACA" = "Threonine", "ACG" = "Threonine", 
    "GCU" = "Alanine", "GCC" = "Alanine", "GCA" = "Alanine", "GCG" = "Alanine",
    "UAU" = "Tyrosine", "UAC" = "Tyrosine", "UAA" = "Stop", "UAG" = "Stop", 
    "UGA" = "Stop", "CAU" = "Histidine", "CAC" = "Histidine",
    "CAA" = "Glutamine", "CAG" = "Glutamine", "AAU" = "Asparagine", 
    "AAC" = "Asparagine", "AAA" = "Lysine", "AAG" = "Lysine",
    "GAU" = "Aspartic Acid", "GAC" = "Aspartic Acid",  "GAA" = "Glutamic Acid", 
    "GAG" = "Glutamic Acid", "UGU" = "Cysteine", "UGC" = "Cysteine",
    "UGG" = "Tryptophan", "CGU" = "Arginine", "CGC" = "Arginine", 
    "CGA" = "Arginine", "CGG" = "Arginine", "AGU" = "Serine", "AGC" = "Serine",
    "AGA" = "Arginine", "AGG" = "Arginine", "GGU" = "Glycine", "GGC" = "Glycine",
    "GGA" = "Glycine", "GGG" = "Glycine"
  )
  return(genetic_code[[codon]])
}

# (1,1)
AA_frequencies <- function(sequence) {
  codons <- split_into_codons(sequence)
  amino_acids <- character(0)
  stop_codons <- 0  # count stop codons
  
  for (codon in codons) {
    aa <- translate_codon(codon)
    if (aa == "Stop") {
      stop_codons <- stop_codons + 1
    } else {
      amino_acids <- c(amino_acids, aa)
    }
  } 
  
  freq_table <- table(amino_acids)
  list(frequencies = freq_table, stop_codons = stop_codons)
}

# Test
rna_sequence <- gen_rna_seq(300)
result <- AA_frequencies(rna_sequence)
print(result$frequencies)
cat("Stop codons:", result$stop_codons, "\n")

