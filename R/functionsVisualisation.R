plot_aa_distribution_by_length <- function(P) {
  ggplot(P, aes(x = factor(Length), y = Proportion, fill = AminoAcid)) +
    geom_bar(stat = "identity", position = "stack") +
    scale_fill_viridis_d(option = "turbo") +  
    theme_minimal(base_size = 14) +
    labs(
      title = "Distribution of Amino Acids by Sequence Length",
      x = "Sequence Length",
      y = "Amino Acids Proportion",
      fill = "Amino Acids"
    ) +
    theme(
      legend.position = "right",
      legend.title = element_text(size = 12, face = "bold"),
      axis.title = element_text(face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1), 
      plot.title = element_text(face = "bold", hjust = 0.5)
    ) +
    facet_wrap(~Type, scales = "free_y") +  # Split comp and ori
    theme(
      legend.position = "right",
      legend.title = element_text(size = 12, face = "bold"),
      axis.title = element_text(face = "bold"),
      plot.title = element_text(face = "bold", hjust = 0.5)
    )
}

plotCodonRedundancyAA <- function(data){
  ggplot(data, aes(x = CodonCount, y = Proportion)) +
  geom_point(aes(color = AminoAcid), size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
  scale_color_viridis_d(option = "turbo") +
  theme_minimal(base_size = 14) +
  labs(
    title = "Correlation AA Proportion/Codon Redundancy",
    x = "Number of Codons per Amino Acid",
    y = "Mean Proportion",
    color = "Amino Acid"
  ) +
  theme(
    legend.position = "right",  # Position de la légende
    legend.title = element_text(size = 12, face = "bold"),  # Titre de la légende
    legend.text = element_text(size = 10),  # Taille du texte de la légende
    legend.key.size = unit(1, "lines"),  # Taille de l'élément de légende (carré de couleur)
    legend.spacing.y = unit(0.4, "lines"),  # Espacement vertical entre les éléments de la légende
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotation des étiquettes de l'axe x
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.text = element_text(size = 10)  # Taille des textes sur les axes
  ) +
  annotate("text", x = max(data$CodonCount) * 0.75, y = max(data$Proportion) * 0.9, 
           label = paste("Spearman r =", round(correlation_result, 3)), 
           color = "black", size = 5, fontface = "bold")
}

# Compute the comparison data between the original and complementary strands
plotAAProportionsOrigComp <- function(comparison_summary){
  comparison_summary %>%
    ggplot(aes(x = Length, y = Diff_Proportion)) +
    geom_point(aes(color = "Difference"), size = 3) +
    geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
    scale_color_manual(values = c("Difference" = "blue")) +
    theme_minimal(base_size = 14) +
    labs(
      title = "Difference in AA Proportions Original vs Complementary",
      x = "Sequence Length",
      y = "Difference in Proportion"
    ) +
    theme(
      legend.position = "none",
      legend.title = element_text(size = 12, face = "bold"),
      axis.title = element_text(face = "bold", size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.title = element_text(face = "bold", hjust = 0.5)
    )
}


plot_aa_distribution_by_melting_temp <- function(P) {
  ggplot(P, aes(x = MeanTm, y = Proportion, color = Type)) + 
    geom_point(aes(shape = Type), size = 3) +  # Type splitting
    geom_smooth(method = "lm", se = FALSE, linetype = "dashed") +  
    scale_color_viridis_d(option = "turbo") +  
    theme_minimal(base_size = 14) +
    labs(
      title = "Distribution of Amino Acids by Melting Temperature",
      x = "Melting Temperature (°C)",
      y = "Amino Acids Proportion",
      color = "Type"
    ) +
    theme(
      legend.position = "right",
      legend.title = element_text(size = 12, face = "bold"),
      axis.title = element_text(face = "bold"),
      plot.title = element_text(face = "bold", hjust = 0.5)
    )
}

displayComparison <- function(compData) {
  ggplot(comparison_summary, aes(x = AminoAcid, y = as.factor(Length), fill = Diff_Proportion)) +
    geom_tile(color = "white") +
    scale_fill_gradient(low = "white", high = "red") +
    labs(title = "Original/Complementary sequence proportions differences",
         x = "Amino Acid",
         y = "Sequence Length",
         fill = "Difference") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))}
