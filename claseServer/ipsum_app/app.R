library(shiny)
library(shinipsum)

ui <- fluidPage(
  titlePanel("Mi Shiny app de prueba"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("selector", "Selector de algo", choices = c("Opción A", "Opción B")),
      checkboxGroupInput("checkbox", "Opciones", choices = c(1,2,3))
    ),
    
    mainPanel(
      fluidRow(
        column(6, plotOutput("grafico")),
        column(6, tableOutput("tabla"))))
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