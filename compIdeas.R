# Drafts

# Define the number of repetitions
num_repetitions <- 100

# Store the results of each repetition in a list
results_list <- list()

for (i in 1:num_repetitions) {
  # Generate random RNA sequence
  rna_sequence <- gen_rna_seq(500)  # Example RNA sequence
  comp_rna_sequence <- gen_comp_rna_seq(rna_sequence)
  
  # Get amino acid frequencies for both sequences
  result_original <- get_amino_acid_frequencies(rna_sequence)
  result_complementary <- get_amino_acid_frequencies(comp_rna_sequence)
  
  # Ensure both result tables are using the same set of amino acids
  all_aminos <- unique(c(names(result_original$frequencies), names(result_complementary$frequencies)))
  
  # Initialize the frequencies (to ensure both sequences have frequencies for all amino acids)
  original_freq <- rep(0, length(all_aminos))
  complementary_freq <- rep(0, length(all_aminos))
  
  # Set the names for easy lookup
  names(original_freq) <- all_aminos
  names(complementary_freq) <- all_aminos
  
  # Populate the frequencies from the results
  original_freq[names(result_original$frequencies)] <- result_original$frequencies
  complementary_freq[names(result_complementary$frequencies)] <- result_complementary$frequencies
  
  # Create a data frame with amino acid frequencies for both sequences
  comparison_data <- data.frame(
    AminoAcid = all_aminos,
    Original_Proportion = original_freq / sum(original_freq),
    Complementary_Proportion = complementary_freq / sum(complementary_freq)
  )
  
  # Reorder AminoAcid based on the absolute difference in proportions
  comparison_data <- comparison_data %>%
    mutate(AminoAcid = fct_reorder(AminoAcid, abs(Original_Proportion - Complementary_Proportion), .desc = TRUE))
  
  # Append the result to the list
  results_list[[i]] <- comparison_data
}


# Combine all the individual results into one large data frame
long_term_data <- bind_rows(results_list)

# Calculate the mean differences across all repetitions
mean_comparison_data <- long_term_data %>%
  group_by(AminoAcid) %>%
  summarise(
    Mean_Original_Proportion = mean(Original_Proportion),
    Mean_Complementary_Proportion = mean(Complementary_Proportion),
    Mean_Proportion_Difference = mean(abs(Original_Proportion - Complementary_Proportion)),
    .groups = 'drop'
  ) %>%
  mutate(AminoAcid = fct_reorder(AminoAcid, Mean_Proportion_Difference, .desc = TRUE))

# Plot the mean differences
ggplot(mean_comparison_data, aes(y = AminoAcid, x = Mean_Proportion_Difference)) +
  geom_bar(stat = "identity", fill = "gray", width = 0.6) +
  labs(title = "Average Differences in Amino Acid Proportions: Original vs Complementary",
       x = "Mean Proportion Difference (Original - Complementary)", y = "Amino Acid") +
  scale_x_continuous() +
  theme_minimal()

ggsave("Comp_Original_strands_proportion_comparison.jpeg", width = 8, height = 6, dpi = 300)

