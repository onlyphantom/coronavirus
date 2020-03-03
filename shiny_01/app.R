# shiny_01
#

library(shiny)

ui <- fluidPage(
  title = "COVID-19",
  titlePanel("Containing Epidemics: 2019-nCoV"),
  sidebarLayout(
    sidebarPanel(
      textInput("plotTitle", label="Title of Visual:"),
      sliderInput("plotSlider", label="Number of Cases", 10, 100, 70, step = 10),
      selectInput("input1",
                  label="Select a Country",
                  choices=c("Singapore", "Japan", "Korea", "United Kingdom", "Malaysia"),
                  selected="Singapore"),
      helpText("Modify the values in the widget to reactively configure the plot.")
    ),
    mainPanel(
      plotOutput("plot1"),
      tableOutput("table1")
    )
  )
)

server <- function(input, output){
  
  dat <- read.csv("../data_input/corona.csv", stringsAsFactors = FALSE)
  dat$date <- as.Date(dat$date)

  output$plot1 <- renderPlot({
    country <- switch(input$input1,
                      "Singapore" = "SG",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB",
                      "Malaysia" = "MY"
    )
    x <- dat[dat$countryCode == country, ]
    plot(x$date, x$confirmed, type="l", main=input$plotTitle)
    lines(x[,c("date", "cured")], col="blue")
  })
  
  output$table1 <- renderTable({
    # output only the important columns
    dat[1:100, ]
  }) # ends renderTable
  
} # ends Server

shinyApp(ui, server)
