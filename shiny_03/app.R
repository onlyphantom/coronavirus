# shiny_03
#

library(shiny)
library(ggplot2)
library(reshape2)

source("preprocess.R")

ui <- fluidPage(
  title = "COVID-19",
  titlePanel(
    h3("Overall Country-level Statistics")
  ),
  sidebarLayout(
    mainPanel(
      plotOutput("sgCasevsCured"),
      hr(),
      div(
        h3("Dataset Source"),
        p("Lorem ipsum Lorem ipsumLorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum", 
          code("preprocess.R"),
          span("renders the processing"), 
          "Lorem ipsum"),
        style="font-weight:lighter"),
      img(src="corgi.png", width="10%", style="margin:3%"), 
      p("For an introduction to the COVID-19 research team, visit ",
        a("Corgi Research", href = "https://corgi.re"), "or talk to a researcher on our team."),
      style="font-weight:lighter"
    ),
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
      # Not implemented yet!
      downloadButton("saveAction", label = "Download Plot", style="background:#F4D258;"),
      style="background:black;color:white;"
    )
    
  )
)

server <- function(input, output){
  
  corona <- read.csv("corona.csv")
  long <- tolong(corona)
  
  output$sgCasevsCured <- renderPlot({
    country <- switch(input$countrySelector,
                      "Singapore" = "SG",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB",
                      "Malaysia" = "MY",
                      "China" = "CN"
    )
    
    geoms <- switch(as.character(input$smoothSelector), "TRUE"=geom_smooth(), "FALSE"=geom_line())
    
    ggplot(data=subset(long, 
                       (countryCode == country 
                          & date >= input$dateSelector[1]
                          & date < input$dateSelector[2]
                        )), 
           aes(x=date, y=value, col=variable)) +
      geoms +
      labs(title = input$titleInput) +
      theme_linedraw()
  })
  
}

shinyApp(ui, server)