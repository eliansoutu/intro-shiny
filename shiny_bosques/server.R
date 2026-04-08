function(input, output, session) {

  
  # Mapa
    output$mapaBienvenida <- renderHighchart({
      
      mapa
      
    })


    #Render de value boxes
    output$valorSuperficie <- renderText({
      
      data %>% 
        filter(anio == max(anio), indicator_name == "Superficie") %>%
        slice_max(valor, n = 1) %>% 
        pull(valor)
      
    })
    
    output$paisSuperficie <- renderText({
      
      data %>% 
        filter(anio == max(anio), indicator_name == "Superficie") %>%
        slice_max(valor, n = 1) %>% 
        pull(country_name)
      
    })    
    
    
    output$valorCobertura <- renderText({
      
      data %>% 
        filter(anio == max(anio), indicator_name == "Cobertura") %>%
        slice_max(valor, n = 1) %>% 
        pull(valor)
      
    })
    
    output$paisCobertura <- renderText({
      
      data %>% 
        filter(anio == max(anio), indicator_name == "Cobertura") %>%
        slice_max(valor, n = 1) %>% 
        pull(country_name)
      
    })
  
    
    # Grafico top
    output$graficoTop <- renderHighchart({
      
      data %>% 
        filter(anio == max(anio),
               indicator_name == input$botonIndicador) %>% 
        slice_max(valor, n = 10) %>% 
        hchart("column", hcaes(country_name, valor), color = "darkgreen")
    })
    
    
    data_serie <- reactive({
      
      req(input$selectPais)
      
      data %>% 
        filter(country_name %in% input$selectPais,
               anio >= input$sliderPeriodo[1] &
                 anio <= input$sliderPeriodo[2]) %>% 
        pivot_wider(names_from = indicator_name,
                    values_from = valor)
      
    })
    
    
    output$graficoSerie <- renderHighchart({
      
      data_serie() %>% 
        hchart("line", hcaes(anio, Superficie, group = country_name))
    })
    
    output$tablaSerie <- renderDataTable({
      
      datatable(
        data_serie() %>% 
          select(anio, country_name, Superficie, Cobertura),
        options = list(pageLength = 8)
      )
    })

    
    observeEvent(eventExpr = input$selectRegion, {
    
      opciones_paises <- data %>% 
        filter(region == input$selectRegion) %>% 
        pull(country_name) %>% unique() %>% sort()
      
      updateSelectizeInput(inputId = "selectPais", choices = opciones_paises)
    }
    )
    
    observeEvent(input$selectPais, {
      
      if (length(input$selectPais) == 6) {
        
        shinyalert(title = "Cuidado!",text = "Alcanzaste el máximo de 6 países", type = "error")
      }
    })
 
    output$btnDescarga <- downloadHandler(
      filename = "grafico.png",
      content = function(file) {
       png(file)
        data_serie() %>% 
          hchart("line", hcaes(anio, Superficie, group = country_name))
        dev.off()
      }, contentType = "image/png"
    ) 
    
    output$btnDescargaData <- downloadHandler(
      filename = "serie_datos_bosques_total.xlsx",
      content = function(file) {
        writexl::write_xlsx(data, file)
      }
    ) 
}
