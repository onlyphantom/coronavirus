library(shiny)

ui <- fluidPage(
  title = "COVID-19",
  titlePanel("Containing Epidemics: 2019-nCoV"),
  sidebarLayout(
    sidebarPanel(
      selectInput("countrySelector",
                  label="Select a Country",
                  choices=c("Singapore", "China", "Japan", "Korea", "United Kingdom"),
                  selected="Singapore")
    ),
    mainPanel(
      plotOutput("sgCasevsCured")
    )
  )
)

server <- function(input, output){
  
  dat <- read.csv("corona.csv", stringsAsFactors = FALSE)
  dat$date <- as.Date(corona$date)


  
  output$sgCasevsCured <- renderPlot({
    
    country <- switch(input$countrySelector,
                      "Singapore" = "SG",
                      "China" = "CN",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB"
    )
    sg <- dat[dat$countryCode == country, ]
    plot(sg[,c("date", "confirmed")], type="s")
    lines(sg[,c("date", "cured")], col="blue")
  })
  
}

shinyApp(ui, server)