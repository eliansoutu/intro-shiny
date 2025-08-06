library(shiny)
library(bslib)
library(tidyverse)
library(plotly)

penguins <- palmerpenguins::penguins

ui <- page_sidebar(
  
  title = "Exploración de Palmer Penguins",
  
  sidebar = sidebar(width = 400, 
                    
                    #Creamos inputs automatizados
                    selectInput("islandSelect", "Isla", unique(penguins$island),
                                multiple = T),
                    
                    sliderInput("bodySlider", "Masa corporal", 
                                min = min(penguins$body_mass_g, na.rm = T),
                                max = max(penguins$body_mass_g, na.rm = T),
                                value = c(min(penguins$body_mass_g, na.rm = T), 
                                          max(penguins$body_mass_g, na.rm = T))),
                    
                    actionButton("botonFiltro", "Filtrar datos"),
                    
                    br(),
                    
                    imageOutput("penguinImage", height = 50)
                    
  ),
  
  layout_columns(
  plotlyOutput("plotPenguin"),
  
  tableOutput("tablePenguin")
  ),
  
  helpText("Fuente: https://allisonhorst.github.io/palmerpenguins/index.html")
  
)

server <- function(input, output, session) {
  
  #Creamos objeto reactivo
  data <- reactive({
    
    penguins %>% 
    filter(island %in% input$islandSelect,
           body_mass_g >= input$bodySlider[1] &
             body_mass_g <= input$bodySlider[2])
    
  }) %>% bindEvent(input$botonFiltro)
  

  output$plotPenguin <- renderPlotly({
    
    #Generamos ggplot con reactivo
    plot <- ggplot(data(), aes(bill_length_mm, bill_depth_mm, color = species)) +
      geom_point() +
      theme_minimal()
    
    #Convertimos en plotly
    ggplotly(plot)
    
  })
  
  output$tablePenguin <- renderTable({ 
    
    head(data())
    
    })
  
  output$penguinImage <- renderImage({
    
    list(src = "penguins.png",
         width = 360,
         height = 200,
         alt = "Palmer penguins")
    
  }, deleteFile = F)
  
}

shinyApp(ui, server)