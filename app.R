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
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)