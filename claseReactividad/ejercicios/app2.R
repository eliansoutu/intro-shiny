library(shiny)
library(bslib)
library(DT)

data <- iris

ui <- page_fluid(
  
  layout_sidebar(
    
    sidebar = sidebar(
      
      selectInput("selectSpecies", "Especie", c("Setosa","virginica","versicolor"))
      
    ),
    
    textOutput(paste0("Usted seleccionó la opción: ", input$selectSpecies)),
    
    dataTableOutput("tableIris")
    
  )
)

server <- function(input, output) {
  
  reactivo <- reactive({
    
    subset(data, Species == input$selectSpecie)
    
  })
  
  
  output$tableIris <- renderDT({ reactivo })
  
}

shinyApp(ui, server)