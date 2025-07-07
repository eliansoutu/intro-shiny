library(shiny)
library(bslib)
library(DT)
library(dplyr)
library(ggplot2)
library(googlesheets4)

gs4_deauth()

#Cargo datos
datos_inscriptos <- read_sheet("https://docs.google.com/spreadsheets/d/1r8JgMcdZ62ZsWmyqcGCQkv43onpbTMCnqiFr16FDW0U/edit?hl=es#gid=0") %>% 
  janitor::clean_names()


ui <- page_sidebar(
  title = "Visualización de Inscriptos al Curso",
  sidebar = sidebar(
    width = 300,
    h4("Filtros"),
    selectInput("filtro_lugar", "Filtrar por lugar:",
                choices = c("Todos" = "", unique(datos_inscriptos$lugar)),
                selected = ""),
    selectInput("filtro_profesion", "Filtrar por profesión/cargo:",
                choices = c("Todos" = "", unique(datos_inscriptos$profesion_cargo)),
                selected = ""),
    textInput("buscar_nombre", "Buscar por nombre:",
              placeholder = "Ingrese nombre..."),
    hr(),
    h4("Información General"),
    verbatimTextOutput("resumen_datos")
  ),
  
  navset_card_tab(
    nav_panel("Tabla de Inscriptos",
              card(
                card_header("Lista completa de inscriptos"),
                DT::dataTableOutput("tabla_inscriptos")
              )
    ),
    nav_panel("Análisis por Lugar",
              card(
                card_header("Distribución por lugar de procedencia"),
                plotOutput("grafico_lugar")
              )
    ),
    nav_panel("Análisis por Profesión",
              card(
                card_header("Distribución por profesión/cargo"),
                plotOutput("grafico_profesion")
              )
    ),
    nav_panel("Temas e Ideas",
              card(
                card_header("Temas e ideas de interés"),
                verbatimTextOutput("lista_temas")
              )
    ),
    nav_panel("Expectativas",
              card(
                card_header("Expectativas de los participantes"),
                verbatimTextOutput("lista_expectativas")
              )
    )
  )
)

server <- function(input, output, session) {
  
  # Datos filtrados reactivos
  datos_filtrados <- reactive({
    datos <- datos_inscriptos
    
    # Filtro por lugar
    if (input$filtro_lugar != "") {
      datos <- datos[datos$lugar == input$filtro_lugar, ]
    }
    
    # Filtro por profesión
    if (input$filtro_profesion != "") {
      datos <- datos[datos$profesion_cargo == input$filtro_profesion, ]
    }
    
    # Búsqueda por nombre
    if (input$buscar_nombre != "") {
      datos <- datos[grepl(input$buscar_nombre, datos$nombre, ignore.case = TRUE), ]
    }
    
    return(datos)
  })
  
  # Resumen de datos
  output$resumen_datos <- renderText({
    total <- nrow(datos_filtrados())
    lugares <- length(unique(datos_filtrados()$lugar))
    profesiones <- length(unique(datos_filtrados()$profesion_cargo))
    
    paste0("Total inscriptos: ", total, "\n",
           "Lugares únicos: ", lugares, "\n",
           "Profesiones únicas: ", profesiones)
  })
  
  # Tabla de inscriptos
  output$tabla_inscriptos <- DT::renderDataTable({
    DT::datatable(datos_filtrados(), 
                  options = list(pageLength = 10, scrollX = TRUE),
                  colnames = c("Nombre", "Lugar", "Profesión/Cargo", "Temas/Ideas", "Expectativas"))
  })
  
  # Gráfico por lugar
  output$grafico_lugar <- renderPlot({
    datos_lugar <- datos_filtrados() %>%
      count(lugar) %>%
      arrange(desc(n))
    
    ggplot(datos_lugar, aes(x = reorder(lugar, n), y = n)) +
      geom_col(fill = "steelblue", alpha = 0.7) +
      coord_flip() +
      labs(title = "Número de inscriptos por lugar",
           x = "Lugar",
           y = "Cantidad de inscriptos") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  # Gráfico por profesión
  output$grafico_profesion <- renderPlot({
    datos_profesion <- datos_filtrados() %>%
      count(profesion_cargo) %>%
      arrange(desc(n))
    
    ggplot(datos_profesion, aes(x = reorder(profesion_cargo, n), y = n)) +
      geom_col(fill = "darkgreen", alpha = 0.7) +
      coord_flip() +
      labs(title = "Número de inscriptos por profesión/cargo",
           x = "Profesión/Cargo",
           y = "Cantidad de inscriptos") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  # Lista de temas
  output$lista_temas <- renderText({
    temas <- datos_filtrados()$temas_ideas
    paste(paste0("• ", temas), collapse = "\n")
  })
  
  # Lista de expectativas
  output$lista_expectativas <- renderText({
    expectativas <- datos_filtrados()$expectativas
    paste(paste0("• ", expectativas), collapse = "\n")
  })
}

shinyApp(ui = ui, server = server)
