library(bslib)
library(shiny)
library(shinipsum)

ui <- page_fluid(title = "Mi Shiny app de prueba",
  
  layout_sidebar(
    sidebar = sidebar(
      selectInput("selector", "Selector de algo", choices = c("Opción A", "Opción B")),
      checkboxGroupInput("checkbox", "Opciones", choices = c(1,2,3))
    ),
    
    layout_columns(plotOutput("grafico"),
                   tableOutput("tabla"))
  )
)


server <- function(input, output) {
  
  output$grafico <- renderPlot({
    random_ggplot("bar")
  })
  
  output$tabla <- renderTable({
    random_table(10, 5)
  })
  
}
shinyApp(ui, server)