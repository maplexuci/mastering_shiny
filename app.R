library(shiny)

ui <- fluidPage(
  textInput("name", "", placeholder = "Your name"),
  sliderInput("date", "When should we deliver?", min = as.Date("2020-09-16"), max = as.Date("2020-09-23"), 
              value = as.Date("2020-09-17"), timeFormat = "%F"),
  sliderInput("number", "Automatic Number Selector", min = 0, max = 100, value = 0, step = 5,
              animate = animationOptions(interval = 500, loop = TRUE, playButton = "Auto scroll")),

  selectInput("Provience", "Choose a Province:",
    list('North' = list("YK", "NT", "NU"),
         'West' = list("BC", "AB", "MB"),
         'South' = list("ON", "QB"),
         'East' = list("NL", "NB", "NS", "PEI"))
  ),
  
  textOutput("text"),
  verbatimTextOutput("code"),
  
  plotOutput("plot", width = "400px"),
  
  tableOutput("static"),
  dataTableOutput("dynamic")
)

server <- function(input, output, session) {
  # textOutput() corresponds to renderText()
  output$text <- renderText({
    "Hello friend!"
  })
  
  # verbatimTextOutput() corresponds to renderPrint()
  output$code <- renderPrint({
    summary(1:10)
  })
  
  output$plot <- renderPlot(plot(1:5), res = 96)
  
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, 
    options = list(searching = FALSE, ordering = FALSE)
    # options = list(pageLength = 5)
    )
}

shinyApp(ui, server)