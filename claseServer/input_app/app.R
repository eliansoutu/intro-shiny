library(shiny)
library(bslib)
library(tidyverse)
library(plotly)

penguins <- palmerpenguins::penguins

ui <- page_sidebar(
  
  title = "Exploración de Palmer Penguins",

    sidebar = sidebar(width = 400, 
      
      #Creamos inputs automatizados
      selectInput("islandSelect", "Isla", unique(penguins$island)),
      
      sliderInput("bodySlider", "Masa corporal", 
                  min = min(penguins$body_mass_g, na.rm = T),
                  max = max(penguins$body_mass_g, na.rm = T),
                  value = c(min(penguins$body_mass_g, na.rm = T), 
                            max(penguins$body_mass_g, na.rm = T))),
      
      br(),
      
      imageOutput("penguinImage", height = 50)
      
    ),
      
    plotlyOutput("plotPenguin"),
    
    helpText("Fuente: https://allisonhorst.github.io/palmerpenguins/index.html")
    
)

server <- function(input, output, session) {
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  #Renderizamos nuestro plot
  output$plotPenguin <- renderPlotly({

    #Aplicamos filtros accediendo a los valores de inputs y asignamos a objeto
    data <- penguins %>%
      filter(island == input$islandSelect,
             body_mass_g >= input$bodySlider[1] &
               body_mass_g <= input$bodySlider[2])

    #Generamos ggplot con los datos filtrados
    plot <- ggplot(data, aes(bill_length_mm, bill_depth_mm, color = species)) +
      geom_point() +
      theme_minimal()

    #Converitmos en plotly
    ggplotly(plot)

  })
  
  output$penguinImage <- renderImage({
    
    list(src = "../recursos/penguins.png",
         width = 360,
         height = 200,
         alt = "Palmer penguins")
    
  }, deleteFile = F)
  
}

shinyApp(ui, server)