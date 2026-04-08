page_navbar(
  title = "Shiny bosques",
  theme = bs_theme(bootswatch = "litera"),
  
  nav_panel(
    title = "Bienvenida",
    icon = bs_icon("info-circle"),
    
    
    tags$p("Bienvenidos al tablero de Shiny Bosques", 
           tags$b("elaborado el marco del curso de Estación R"),
           "a partir de datos del", tags$a("Banco Mundial", href = "https://data.worldbank.org/",
                                           target = "_blank")),
    
    card(
      card_header("Mapa de los países por cobertura"),
      card_body( highchartOutput(outputId = "mapaBienvenida"))
    )
   
    
  ),
  
  nav_panel(
    title = "Análisis",
    icon = bs_icon("tree"),
    
    
    navset_card_tab(
      
      nav_panel(
        title = "Últimos datos",
        
        layout_columns(
          
          value_box(title = "País con mayor superficie",
                    value = textOutput("valorSuperficie"),
                    textOutput("paisSuperficie"),
                    showcase = bs_icon("tree"),
                    theme = "teal"),
          value_box(title = "País con mayor cobertura",
                    value = textOutput("valorCobertura"),
                    textOutput("paisCobertura"),
                    showcase = bs_icon("tree"),
                    theme = "green")
          
        ),
        
        card(
          card_header("Top países según indicador"),
          card_body(
            
            radioGroupButtons("botonIndicador",
                              "Elegir indicador",
                              choices = unique(data$indicator_name)),
            
            
            highchartOutput("graficoTop")
          )
        )
        
      ),
      
      nav_panel("Serie",
                
                layout_sidebar(
                  
                  sidebar = sidebar(
                    
                    selectInput("selectRegion", "Región", unique(data$region)),
                    
                    selectizeInput("selectPais", "País", unique(data$country_name),
                                   multiple = T,
                                   options = list(maxItems = 6)),
                    
                    sliderInput("sliderPeriodo", label = "Años", 
                                min = min(data$anio), max = max(data$anio),
                                value = c(min(data$anio), max(data$anio)),
                                sep = "")
                  ),
                  
                  
                  layout_columns(
                    
                    highchartOutput("graficoSerie"),
                    
                    dataTableOutput("tablaSerie")
                  ),
                  
                  layout_columns(
                  downloadButton("btnDescarga", "Descargar datos filtrados"),
                  downloadButton("btnDescargaData", "Descargar todos los datos")
                  )
                )
                
                )
    )
    
  )
  
  
  
)
