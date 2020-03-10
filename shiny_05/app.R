# shiny_05
#

library(shiny)
library(ggplot2)
library(shinythemes)
library(plotly)

source("reader.r")
source("preprocess.R")
source("darker.R")

ui <- fluidPage(
  theme = shinytheme("darkly"),
  tags$style(HTML('table.dataTable tr:nth-child(even) {color: black !important;}')),
  tags$style(HTML('table.dataTable tr:nth-child(odd) {background-color: black !important;}')),
  tags$style(HTML('table.dataTable th {color: black !important;}')),
  tags$style(HTML('table.dataTable th {background-color: white !important;}')),
  title = "COVID-19",
  titlePanel(
    img(src="coronalogo.png", width="20%", style="margin:3%"), 
    h3("Overall Country-level Statistics")
  ),
  sidebarLayout(
    mainPanel(
      tabsetPanel(
        tabPanel(
          "County-wide Statistics",
          plotlyOutput("allCountries"),
          hr(),
          div(
            h3("Dataset Source"),
            p("This repo is created as part of a tutorial / workshop series intended to ease programming beginners into the world of Shiny web apps. Refer to the code in", 
              code("preprocess.R"),
              span("to see the full data cleansing script"), br(),
              "Follow me on github at", a("@onlyphantom", href = "https://github.com/onlyphantom")),
            style="font-weight:lighter"), # end div
          
          img(src="corgi.png", width="10%", style="margin:3%"), 
          p("For more materials on Web App development in Python and R, follow ",
            a("me on github", href = "https://github.com/onlyphantom"), 
            "or connect with me on your favorite social network.", style="font-weight:lighter")
          ), # end tabPanel-1
        tabPanel("Tabular Data",
                 DT::DTOutput("tabular")
                 )
        
      ) # end tabsetPanel
    ), # end mainPanel

    sidebarPanel(
      helpText("Use the widget below to reactively
               generate the plot elements."),
      selectInput("countrySelector",
                  label="Select a Country",
                  choices=c("Singapore", "Japan", "South Korea", "UK", "Malaysia", "Mainland China"),
                  selected="Singapore"),
      dateRangeInput("dateSelector",
                     label = "Observation Period",
                     start = as.Date("2020-01-01"),
                     end = as.Date("2020-02-20"),
                     min = as.Date("2019-12-01"),
                     max = as.Date("2020-02-23"),
                     separator = "to"
                    ),
      checkboxInput("smoothSelector",
                    label = "Smoother?", value=FALSE),
      textInput("titleInput", label = "Plot Title"),
      downloadButton("saveAction", label = "Download Plot", style="background:#F4D258;color:black"),
      style="background:black;color:white;"
    )
    
  )
)

corona <- read_github()
long <- tolong(corona)

server <- function(input, output){
  
  dat <- reactive({
    x <- subset(long, 
           (country == input$countrySelector
            & date >= input$dateSelector[1]
            & date < input$dateSelector[2]
            ))
    return(x)
  })
    

  output$allCountries <- renderPlotly({
    geoms <- switch(as.character(input$smoothSelector), 
                    "TRUE"=geom_smooth(size=1.2), 
                    "FALSE"=geom_line(size=1.2))
    ggplotly(
      ggplot(data=dat(), 
             aes(x=date, y=value, col=variable)) +
        geoms +
        labs(title = input$titleInput) +
        grim
    )
  })
  
  output$saveAction <- downloadHandler(
    filename = 'plotFromApp.png',
    content = function(file) {
      ggsave(file, dat())
    }
  )

  
  output$tabular <- DT::renderDT({
    x <- corona[corona$country == input$countrySelector,]
    return(x)
  })
  
}

shinyApp(ui, server)