library(datasets)
library(shiny)
library(bslib)

#Activar plot thematic
thematic::thematic_shiny()

# Use a fluid Bootstrap layout
ui <- fluidPage(
  
  ### shinythemes
  #theme = shinythemes::shinytheme("darkly"),
  
  ### shinythemes selector
  #shinythemes::themeSelector(),
  
  ### bslib theme
  #theme = bslib::bs_theme(bootswatch = "superhero"),
  
  ### bslib theme editado
  # theme = bslib::bs_theme(bootswatch = "superhero", 
  #                         bg = "#495660", 
  #                         base_font = "San Serif", 
  #                         fg = "#ebebeb"),  
  
  
  ### css personalizado
  #includeCSS("styles.css"),
    
  # Give the page a title
  titlePanel("Telephones by region"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("region", "Region:", 
                  choices=colnames(WorldPhones)),
      hr(),
      helpText("Data from AT&T (1961) The World's Telephones.")
    ),
    
    # Create a spot for the barplot
    mainPanel(
      plotOutput("phonePlot")  
    )
    
  )
)


# Define a server for the Shiny app
server <- function(input, output) {
  
  ### bslib theme selector
  #bs_themer()
  
  # Fill in the spot we created for a plot
  output$phonePlot <- renderPlot({
    
    # Render a barplot
    barplot(WorldPhones[,input$region]*1000, 
            main=input$region,
            ylab="Number of Telephones",
            xlab="Year")
  })
}

shinyApp(ui, server)