library(shiny)
library(tidyverse)

data <- iris

ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      
      #Select de especie
      selectInput(...)
      
    ),
    
    mainPanel(
      
      #Output
      ...Output(...)
    )
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