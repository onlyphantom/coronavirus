# shiny_04
#

library(shiny)
library(ggplot2)
library(reshape2)
library(shinythemes)

source("preprocess.R")
source("darker.R")

ui <- fluidPage(
  theme = shinytheme("darkly"),
  title = "COVID-19",
  titlePanel(
    h3("Overall Country-level Statistics")
  ),
  sidebarLayout(
    mainPanel(
      tabsetPanel(
        tabPanel(
          "County-wide Statistics",
          plotOutput("sgCasevsCured"),
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
                 dataTableOutput("tabular")
                 )
        
      ) # end tabsetPanel
    ), # end mainPanel

    sidebarPanel(
      selectInput("countrySelector",
                  label="Select a Country",
                  choices=c("Singapore", "Japan", "Korea", "United Kingdom", "Malaysia", "China"),
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

server <- function(input, output){
  
  corona <- read.csv("corona.csv")
  corona$date <- as.Date(corona$date)
  long <- tolong(corona)
 
  ggp <- reactive({
    country <- switch(input$countrySelector,
                      "Singapore" = "SG",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB",
                      "Malaysia" = "MY",
                      "China" = "CN"
    )
    
    geoms <- switch(as.character(input$smoothSelector), "TRUE"=geom_smooth(), "FALSE"=geom_line())
    dat <- subset(long, 
                  (countryCode == country 
                   & date >= input$dateSelector[1]
                   & date < input$dateSelector[2]
                  ))
    ggplot(data=dat, 
           aes(x=date, y=value, col=variable)) +
      geoms +
      labs(title = input$titleInput) +
      grim
  })
  
  output$sgCasevsCured <- renderPlot({
    ggp()
  })
  
  output$saveAction <- downloadHandler(
    filename = 'plotFromApp.png',
    content = function(file) {
      ggsave(file, ggp())
    }
  )
  
  countryReact <- reactive({
    country <- switch(input$countrySelector,
                      "Singapore" = "SG",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB",
                      "Malaysia" = "MY",
                      "China" = "CN"
    )
    corona[corona$countryCode == country & 
             corona$date >= input$dateSelector[1] &
             corona$date < input$dateSelector[2]
             , 
           c("date", "country", "confirmed", "cured", "dead")]
  })
  
  output$tabular <- DT::renderDataTable(
    countryReact()
  )
  
}

shinyApp(ui, server)