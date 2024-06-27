library(shiny)
library(bslib)
library(bsicons)
library(shinipsum)

thematic::thematic_shiny()

# Define UI for application that draws a histogram
ui <- page_navbar(
  title = "App prototipo",
  theme = bs_theme(preset = "litera"),

  nav_panel("Bienvenida",
            
            h3(random_text(nwords = 40)),
            
            layout_columns(
                   imageOutput("imgBienvenida1"),
                   imageOutput("imgBienvenida2"),
                   imageOutput("imgBienvenida3"),
                   imageOutput("imgBienvenida4"),
              col_widths = c(3,3,3,3)
            )
            
            ),
  
  nav_panel("Datos",
            
            
            navset_tab(
              
              nav_panel("Resumen",
                        
            layout_columns(
              value_box(
                title = random_text(nwords = 2),
                value = 100,
                showcase = bs_icon("bank")
              ),
              value_box(
                title = random_text(nwords = 3),
                value = "20%",
                showcase = bs_icon("file-bar-graph")
              ),
              value_box(
                title = random_text(nwords = 1),
                value = -25,
                showcase = bs_icon("geo")
              ),
              col_widths = c(4,4,4)
            ),
            
            plotOutput("plotResumen")
              ),
            
            nav_panel("Análisis",
                      
                      random_text(nwords = 50),
                      
                      fluidRow(
                        column(3, selectInput("input1", "Año", choices = c(2020:2024))),
                        column(3, selectInput("input1", "Mes", choices = c(1:12))),
                        column(3, selectInput("input1", "Categoría", choices = c("A","B"))),
                        column(3, selectInput("input1", "Tipo", choices = c("Tipo 1","Tipo 2")))
                        ),
                      
                      layout_columns(
                        card(card_header("Gráfico",
                                         
                                         plotOutput("plotIpsum"))),
                        
                        card(card_header("Tabla"),
                             
                             tableOutput("tableIpsum"))
                        )
                      
                      )
            )
            
            )
)

server <- function(input, output, session) {
  
  output$imgBienvenida1 <- renderImage({random_image()}, deleteFile = F)
  
  output$imgBienvenida2 <- renderImage({random_image()}, deleteFile = F)
  
  output$imgBienvenida3 <- renderImage({random_image()}, deleteFile = F)
  
  output$imgBienvenida4 <- renderImage({random_image()}, deleteFile = F)
  
  output$plotResumen <- renderPlot({random_ggplot(type = "line")})
  
  output$plotIpsum <- renderPlot({random_ggplot(type = "bar")})
  
  output$tableIpsum <- renderTable({random_table(8,6)})
}

shinyApp(ui = ui, server = server)
