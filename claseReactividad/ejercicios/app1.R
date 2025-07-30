library(shiny)
library(bslib)
library(tidyverse)

data <- iris

ui <- page_fluid(
  
  layout_sidebar(
    
    sidebar = sidebar(
      
      #Select de especie
      selectInput(...)
      
    ),
    
    #Output
    ...Output(...)
    
  )
)

server <- function(input, output) {
  
  #Reactivo
  data <- ...
  
  
  output$... <- render...({
    
    ...
    
  })
  
}

shinyApp(ui, server)