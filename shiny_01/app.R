# shiny_01
#

library(shiny)
library(ggplot2)
library(DT)
library(shinythemes)

ui <- fluidPage(
  title = "COVID-19",
  theme = shinytheme("darkly"),
  tags$style(HTML('table.dataTable tr:nth-child(even) {color: black !important;}')),
  tags$style(HTML('table.dataTable tr:nth-child(odd) {background-color: black !important;}')),
  tags$style(HTML('table.dataTable th {color: black !important;}')),
  tags$style(HTML('table.dataTable th {background-color: white !important;}')),
  fluidRow(
    column(10),
    column(2, 
           img(src="coronalogo.png", width="60%", style="margin:5%"), margin="2%")
  ),
  titlePanel("Containing Epidemics: 2019-nCoV"),
  sidebarLayout(
    sidebarPanel(
      textInput("plotTitle", label="Optional Subtitle:"),
      dateRangeInput("datePicker", 
                     label="Observation Period:", 
                     start=as.Date("2020-02-01"),
                     end=as.Date("2020-02-29"),
                     min=as.Date("2020-01-01"),
                     max=Sys.Date(),
                     ),
      # sliderInput("plotSlider", label="Number of Cases", 10, 100, 70, step = 10),
      selectInput("countrySelector",
                  label="Select a Country",
                  choices=c("Singapore", "Japan", "Korea", "United Kingdom", "Malaysia", "China"),
                  selected="Singapore"),
      helpText("Modify the values in the widget to reactively configure the plot."),
      img(src="coronalogo.png", width="40%")
    ),
    mainPanel(
      # tabSets
      tabsetPanel(
          tabPanel("County-wide Statistics",
                   plotOutput("plot1")),
          tabPanel("Tabular Data",
                   DTOutput("table1")),
          tabPanel("Weekly Summary", tableOutput("table2")),
          tabPanel("Author", 
                   p('Johnny Depp is an experienced business executive with technical expertise.'),
                   hr(),
                   p("Follow me on LinkedIn at", a("@samuelchan", href = "https://www.linkedin.com/in/chansamuel/")),
                   HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/BO3Ce_jZBts" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'))
      )

    )
  )
)


server <- function(input, output){
  dat <- read.csv("../data_input/corona.csv", stringsAsFactors = FALSE, encoding = "utf-8")
  dat$date <- as.Date(dat$date)
  # preprocessing goes here
  # your aggregation function to make the guarantee that
  # each country has one record per day
  # 
  dat <- aggregate(
    x=dat[, c("confirmed", "cured", "dead")], 
    by=dat[, c("date", "countryCode")],
    FUN=sum)
  
  output$plot1 <- renderPlot({
  
    country <- switch(input$countrySelector,
                      "Singapore" = "SG",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB",
                      "Malaysia" = "MY",
                      "China" = "CN"
    )
    x <- dat[(dat$countryCode == country &
                dat$date >= input$datePicker[1] &
                dat$date <= input$datePicker[2]
              ), ]
    # TODO: change color of line OR add a theme
    # TODO: change the x and y labels (labs)
    # TODO: map title of your plot to user text input
    ggplot(x, aes(x=date,y=confirmed)) +
      geom_line(col="hotpink4") +
      theme_linedraw() +
      labs(x="Date", 
           y="Confirmed Cases", 
           title=paste(as.character(input$countrySelector), "COVID-19 Cases",sep=": "),
           subtitle=input$plotTitle
           )
  })
  
  output$table1 <- renderDT({
    # TODO: respond to only the country selector
    country <- switch(input$countrySelector,
                      "Singapore" = "SG",
                      "Japan" = "JP",
                      "Korea" = "KR",
                      "United Kingdom" = "GB",
                      "Malaysia" = "MY",
                      "China" = "CN"
    )
    dat[dat$countryCode == country, ]
  }) # ends renderTable
  
  output$table2 <- renderTable({
    head(dat,10)
  })
  
} # ends Server

shinyApp(ui, server)
