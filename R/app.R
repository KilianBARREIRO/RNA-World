library(shiny)
library(ggplot2)
library(dplyr)

# Suppose que comparison_summary est déjà chargé ou calculé
# Tu peux aussi le charger dans le serveur avec un fichier .rds ou .csv

ui <- fluidPage(
  titlePanel("Comparaison Original vs Complémentaire"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("seqLength", "Longueur de séquence :", 
                  min = min(comparison_summary$Length),
                  max = max(comparison_summary$Length),
                  value = min(comparison_summary$Length),
                  step = 1),
      checkboxInput("showSmooth", "Afficher la tendance", value = TRUE)
    ),
    
    mainPanel(
      plotOutput("diffPlot")
    )
  )
)

server <- function(input, output) {
  output$diffPlot <- renderPlot({
    data_filtered <- comparison_summary %>%
      filter(Length == input$seqLength)
    
    p <- ggplot(data_filtered, aes(x = AminoAcid, y = Diff_Proportion, fill = Diff_Proportion)) +
      geom_col(color = "black") +
      scale_fill_gradient2(low = "red", mid = "white", high = "green4", midpoint = 0) +
      labs(title = paste("Différences AA - Longueur", input$seqLength),
           x = "Acide Aminé", y = "Différence de proportion") +
      theme_minimal(base_size = 14) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    if (input$showSmooth) {
      # Optionnel : on ajoute une ligne de tendance globale (moyenne mobile)
      p <- p + geom_smooth(aes(group = 1), method = "loess", se = FALSE, color = "black", linetype = "dashed")
    }
    
    p
  })
}

shinyApp(ui = ui, server = server)
