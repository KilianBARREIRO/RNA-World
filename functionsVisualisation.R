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
