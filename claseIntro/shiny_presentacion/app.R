library(shiny)
library(googlesheets4)
library(tidyverse)
library(wordcloud)

gs4_deauth()

#Cargo datos
data <- read_sheet("https://docs.google.com/spreadsheets/d/1r8JgMcdZ62ZsWmyqcGCQkv43onpbTMCnqiFr16FDW0U/edit?hl=es#gid=0") %>% 
  pivot_longer(everything())

thematic::thematic_shiny()

#Armo UI
ui <- fluidPage(theme = bslib::bs_theme(bootswatch = "superhero"),

    titlePanel("Participantes del curso Introducción a Shiny"),

    sidebarLayout(
        sidebarPanel(
            selectInput("filtro",
                        "Ver:",
                        choices = unique(data$name),
                        selected = 1
                        )
        ),

        mainPanel(
           plotOutput("wordcloud")
        )
    )
)

#Armo server
server <- function(input, output) {
  
    output$wordcloud <- renderPlot({
      
      words <- data %>% 
        filter(name == input$filtro) %>%
        separate_longer_delim(value, delim = ";") %>% 
        count(value)
        
      wordcloud(words$value,words$n, scale = c(1,2), rot.per = 0, colors = "white")
      
    })
}

#Ejecuto
shinyApp(ui = ui, server = server)
