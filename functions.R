# functions.R

# Think about adding tests to functions

# Generate RNA sequence and its complementary with differents nitrogenous bases.
# complementary = TRUE implies creation of the comp 
genRnaSeq <- function(n, complementary = FALSE) {
  bases <- c("A", "U", "C", "G")
  rna_seq <- paste0(sample(bases, n, replace = TRUE), collapse = "")
  
  if (complementary) {
    rna_comp_seq <- chartr("AUCG", "UAGC", rna_seq)
    return(list(Original = rna_seq, Complementary = rna_comp_seq))
  }
  return(list(Original = rna_seq))
}

# Split in groups of three elements (codons)
splitIntoCodons <- function(sequence) {
  substring(sequence, seq(1, nchar(sequence)-2, by=3), seq(3, nchar(sequence), by=3))
}

# Translate codons to AA names
translate_codon <- function(codon) {
  for (amino_acid in names(codonTable)) {
    if (codon %in% codonTable[[amino_acid]]) {
      return(amino_acid)
    }
  }
  return(NA)  # Return NA if the codon is not found
}

# Temperature melting computing (Easy formula)
calculate_tm <- function(codon) {
  au_count <- str_count(codon, "A|U")
  gc_count <- str_count(codon, "G|C")
  return(2 * au_count + 4 * gc_count)
}

# Get Melting Temperature Data
MeltingTemperature <- function(codonTable){
  data.table(
    Codon = unlist(codonTable),
    AminoAcid = rep(names(codonTable), times = sapply(codonTable, length)),  
    MeltTemp = sapply(unlist(codonTable), calculate_tm)) %>% 
    group_by(AminoAcid) %>%
    mutate(MeanTm = mean(MeltTemp)) %>%
    ungroup()}

# Codon to Amino Acids translation and frequencies counting (occurrences) 
AA_frequencies <- function(sequence, stopCodon = TRUE) {
  codons <- splitIntoCodons(sequence)
  amino_acids <- character(0)
  stop_codons <- 0
  
  for (codon in codons) {
    aa <- translate_codon(codon)
    
    if (aa == "Stop" && stopCodon) {
      stop_codons <- stop_codons + 1
    } else {
      amino_acids <- c(amino_acids, aa)
    }
  }
  
  freq_table <- table(amino_acids)
  list(frequencies = freq_table, stop_codons = stop_codons)
}

# Loop of previous function with size of initial and final sequence, step between
# each chosen length, number of repetitions of the whole process (n_repeats)
Loop_AA_data <- function(begin_size, end_size, step, n_repeats, stopCodon = TRUE,
                         complementary = FALSE) {
  data_list <- list()
  sequence_lengths <- seq(begin_size, end_size, by = step)
  
  for (len in sequence_lengths) {
    for (rep in 1:n_repeats) {
      rna_sequences <- genRnaSeq(len, complementary)
      
      for (seq_type in names(rna_sequences)) { # "Original" / "Complementary"
        freq_data <- AA_frequencies(rna_sequences[[seq_type]], stopCodon)
        
        df <- data.frame(Length = len,
                         AminoAcid = names(freq_data$frequencies),
                         Count = as.numeric(freq_data$frequencies),
                         Type = seq_type)
        
        data_list <- append(data_list, list(df))
      }
    }
  }
  return(data_list)
}

# Data list formatting to plot displaying, to be used with previous one to bind 
# data and get proportions of each AA according to Length and Type (Original or 
# Complementary), subject to be modified in the future
ready2plot_data <- function(data_list) {
  bind_rows(data_list) %>%
    group_by(Length, AminoAcid, Type) %>% 
    summarise(TotalCount = sum(Count), .groups = "drop") %>%
    group_by(Length, Type) %>%  # (Original/Complementary) Normalization
    mutate(Proportion = TotalCount / sum(TotalCount)) %>%  
    ungroup() %>%
    mutate(AminoAcid = forcats::fct_reorder(AminoAcid, Proportion, .desc = TRUE)) 
}

# get codon redundancy for each AA
get_codon_count <- function(aa) {
  if (aa %in% names(codonTable)) {
    return(length(codonTable[[aa]]))  
  }
  return(NA)
}


# Explicit name, compute the difference of proportion between the 2 strands
originalComplementaryComparison <- function(dataset)
  dataset %>%
  complete(Length, AminoAcid = all_aa, Type, fill = list(TotalCount = 0, Proportion = 0)) %>%
  select(Length, AminoAcid, Type, Proportion) %>%
  spread(Type, Proportion) %>%
  rename(Original_Proportion = Original, Complementary_Proportion = Complementary) %>%
  mutate(Diff_Proportion = abs(Original_Proportion - Complementary_Proportion))
  
