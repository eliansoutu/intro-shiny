library(shiny)
library(bslib)
library(DT)

data <- iris

ui <- page_fluid(
  
  layout_sidebar(
    
    sidebar = sidebar(
      
      selectInput("selectSpecies", "Especie", unique(data$Species)) #Automatizo choices
      
    ),
    
    textOutput("textSpecie"), #en UI defino solo ID del Output
    
    dataTableOutput("tableIris")
    
  )
)

server <- function(input, output) {
  
  reactivo <- reactive({
    
    subset(data, Species == input$selectSpecies) #Corrijo ID
    
  })
  
  
  output$tableIris <- renderDT({ reactivo() }) #Agrego ()
  
  #Genero output de texto
  output$textSpecie <- renderText({
    paste0("Usted seleccionó la opción: ", input$selectSpecies)
  })
  
}

shinyApp(ui, server)