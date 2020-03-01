# shiny_02
#

library(shiny)
library(ggplot2)
library(reshape2)

# source("preprocess.R")

ui <- fluidPage(
  title = "COVID-19",
  titlePanel("Containing Epidemics: 2019-nCoV"),
  sidebarLayout(
    sidebarPanel(
      selectInput("countrySelector",
                  label="Select a Country",
                  # TODO: add china to the choices below again
                  choices=c("Singapore", "Japan", "Korea", "United Kingdom", "Malaysia"),
                  selected="Singapore")
    ),
    mainPanel(
      plotOutput("sgCasevsCured")
    )
  )
)

server <- function(input, output){
  
  corona <- read.csv("corona.csv")
  corona$date <- as.Date(corona$date)
  vs <- corona[,c("confirmed", "suspected", "cured", "dead")]
  dat <- aggregate(vs, by=corona[,c("date", "countryCode")], FUN=sum)
  long <- reshape2::melt(data=dat,
                        id.vars=c("date", "countryCode"),
                        measured.vars=c("confirmed", "suspected", "dispatched", "dead"))
  # long <- tolong(corona)
  
  output$sgCasevsCured <- renderPlot({
    country <- switch(input$countrySelector,
                      "Singapore" = "SG",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB",
                      "Malaysia" = "MY",
                      "China" = "CN"
    )
    ggplot(data=subset(long, countryCode == country), aes(x=date, y=value, col=variable)) +
      geom_line() +
      theme_linedraw()
  })
  
}

shinyApp(ui, server)