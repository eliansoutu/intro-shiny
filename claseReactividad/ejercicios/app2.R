library(shiny)
library(DT)

data <- iris

ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("selectSpecies", "Especie", c("Setosa","virginica","versicolor"))
      
    ),
    
    mainPanel(
      
      textOutput(paste0("Usted seleccionó la opción: ", input$selectSpecies)),
      
      dataTableOutput("tableIris")
      
    )
  )
)

server <- function(input, output) {
  
  reactivo <- reactive({
    
    filter(data, Species == input$selectSpecie)
    
  })
  
  
  output$tableIris <- renderDT({ reactivo })
  
}

shinyApp(ui, server)