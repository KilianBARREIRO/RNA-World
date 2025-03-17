# functions.R

# Generate RNA sequence and its complementary with differents nitrogenous bases.
gen_rna_seq <- function(n) {
  bases <- c("A", "U", "C", "G")
  paste0(sample(bases, n, replace = TRUE), collapse = "")
}

gen_comp_rna_seq <- function(rna_seq) {
  chartr("AUCG", "UAGC", rna_seq)
}

# Split in groups of three elements (codons)
split_into_codons <- function(sequence) {
  substring(sequence, seq(1, nchar(sequence)-2, by=3), seq(3, nchar(sequence), by=3))
}

# Translate codons to name
translate_codon <- function(codon) {
  for (amino_acid in names(codonTable)) {
    if (codon %in% codonTable[[amino_acid]]) {
      return(amino_acid)
    }
  }
  return(NA)  # Return NA if the codon is not found
}

# Temperature melting computing 
calculate_tm <- function(codon) {
  au_count <- str_count(codon, "A|U")
  gc_count <- str_count(codon, "G|C")
  return(2 * au_count + 4 * gc_count)
}

# Melting Temperature 
MeltingTemperature <- function(codonTable){
  data.table(
    Codon = unlist(codonTable),
    AminoAcid = rep(names(codonTable), times = sapply(codonTable, length)),  
    MeltTemp = sapply(unlist(codonTable), calculate_tm)) %>% 
    group_by(AminoAcid) %>%
    mutate(MeanTm = mean(MeltTemp)) %>%
    ungroup()}

# Amino Acids frequencies computing and tm computing
AA_frequencies <- function(sequence) {
  codons <- split_into_codons(sequence)
  amino_acids <- character(0)
  stop_codons <- 0
  
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


Loop_AA_data <- function(begin_size, end_size, step, n_repeats){
  data_list <- list()
  sequence_lengths <- seq(begin_size, end_size, by = step)
  #print(sequence_lengths)
  for (len in sequence_lengths) {
    #print(len)
    for (rep in 1:n_repeats) {
      #print(rep)
      rna_sequence <- gen_rna_seq(len)
      freq_data <- AA_frequencies(rna_sequence)
      
      df <- data.frame(Length = len,
                       AminoAcid = names(freq_data$frequencies),
                       Count = as.numeric(freq_data$frequencies))
      
      data_list <- append(data_list, list(df))
    }
  }
  return(data_list)
}


ready2plot_data <- function(data_list){
  bind_rows(data_list) %>%
    group_by(Length, AminoAcid) %>%
    summarise(TotalCount = sum(Count), .groups = "drop") %>%  # Take the raw sum
    group_by(Length) %>%
    mutate(Proportion = TotalCount / sum(TotalCount)) %>%  # Normalization correct
    mutate(AminoAcid = forcats::fct_reorder(AminoAcid, Proportion, .desc = TRUE)) 
  #%>%  left_join(data.frame(AminoAcid = names(freq_data$tm_values), MeltTemp = freq_data$tm_values), by = "AminoAcid")
  #%>%  left_join(tm_data, by = "AminoAcid") #to add if we want to plot according to 1st tm calc
}
