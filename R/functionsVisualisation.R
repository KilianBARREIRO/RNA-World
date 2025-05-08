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
plotAAProportionsOrigComp <- function(comparison_summary) {
  # Régression linéaire
  model_lm <- lm(abs(Diff_Proportion) ~ Length, data = comparison_summary)
  r2_lm <- summary(model_lm)$r.squared
  
  # Régression exponentielle (modèle log-linéaire)
  model_exp <- lm(log(abs(Diff_Proportion)) ~ Length, data = comparison_summary)
  r2_exp <- summary(model_exp)$r.squared
  comparison_summary$pred_exp <- exp(predict(model_exp))  # Prédictions exponentielles
  
  # Régression logarithmique
  model_log <- lm(abs(Diff_Proportion) ~ log(Length), data = comparison_summary)
  r2_log <- summary(model_log)$r.squared
  
  # Graphique avec les trois modèles
  ggplot(comparison_summary, aes(x = Length, y = abs(Diff_Proportion))) +
    geom_point(color = "blue", size = 3) +
    geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +  # Modèle linéaire
    geom_line(aes(y = pred_exp), color = "darkgreen", linewidth = 1.2, linetype = "solid") +  # Modèle exponentiel
    geom_line(aes(y = predict(model_log)), color = "darkorange", linewidth = 1.2, linetype = "solid") +  # Modèle logarithmique
    theme_minimal(base_size = 14) +
    labs(
      title = "Difference in AA Proportions Original vs Complementary",
      x = "Sequence Length",
      y = "Difference in Proportion"
    ) +
    theme(
      legend.position = "none",
      axis.title = element_text(face = "bold", size = 12),
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.title = element_text(face = "bold", hjust = 0.5)
    ) +
    annotate("text", x = max(comparison_summary$Length) * 0.7, 
             y = max(abs(comparison_summary$Diff_Proportion)) * 0.9,
             label = paste("Linear R² =", round(r2_lm, 3)), color = "black", size = 5, fontface = "bold") +
    annotate("text", x = max(comparison_summary$Length) * 0.7, 
             y = max(abs(comparison_summary$Diff_Proportion)) * 0.8,
             label = paste("Exp. R² =", round(r2_exp, 3)), color = "darkgreen", size = 5, fontface = "bold") +
    annotate("text", x = max(comparison_summary$Length) * 0.7, 
             y = max(abs(comparison_summary$Diff_Proportion)) * 0.7,
             label = paste("Log R² =", round(r2_log, 3)), color = "darkorange", size = 5, fontface = "bold")
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
  ggplot(compData, aes(x = AminoAcid, y = as.factor(Length), fill = Diff_Proportion)) +
    geom_tile(color = "white") +
    scale_fill_gradient2(
      low = "blue",
      mid = "white",
      high = "darkred",
      midpoint = 0
    ) +
    labs(title = "Original/Complementary Sequence Proportion Differences",
         x = "Amino Acid",
         y = "Sequence Length",
         fill = "Difference") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

