library(shiny)
library(DT)

data <- iris

ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("selectSpecies", "Especie", unique(data$Species)) #Automatizo choices
      
    ),
    
    mainPanel(
      
      textOutput("textSpecie"), #en UI defino solo ID del Output
      
      dataTableOutput("tableIris")
      
    )
  )
)

server <- function(input, output) {
  
  reactivo <- reactive({
    
    filter(data, Species == input$selectSpecies) #Corrijo ID
    
  })
  
  
  output$tableIris <- renderDT({ reactivo() }) #Agrego ()
  
  #Genero output de texto
  output$textSpecie <- renderText({
    paste0("Usted seleccionó la opción: ", input$selectSpecies)
  })
  
}

shinyApp(ui, server)