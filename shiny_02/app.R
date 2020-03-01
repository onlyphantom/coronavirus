# shiny_02
#

library(shiny)
library(ggplot2)

ui <- fluidPage(
  title = "COVID-19",
  titlePanel("Containing Epidemics: 2019-nCoV"),
  sidebarLayout(
    sidebarPanel(
      selectInput("countrySelector",
                  label="Select a Country",
                  choices=c("Singapore", "Japan", "Korea", "United Kingdom", "Malaysia", "China"),
                  selected="Singapore")
    ),
    mainPanel(
      plotOutput("sgCasevsCured")
    )
  )
)

server <- function(input, output){
  
  corona <- read.csv("../data_input/corona.csv")
  corona$date <- as.Date(corona$date)
  vs <- corona[,c("confirmed", "suspected", "cured", "dead")]
  dat <- aggregate(vs, by=corona[,c("date", "countryCode")], FUN=sum)

  output$sgCasevsCured <- renderPlot({
    country <- switch(input$countrySelector,
                      "Singapore" = "SG",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB",
                      "Malaysia" = "MY",
                      "China" = "CN"
    )
    sg <- dat[dat$countryCode == country, ]
    plot(sg[,c("date", "confirmed")], type="s")
    lines(sg[,c("date", "cured")], col="blue")
  })
  
}

shinyApp(ui, server)