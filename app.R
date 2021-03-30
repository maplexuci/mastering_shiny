library(shiny)

ui <- fluidPage(
  dateInput("dob", "When were you born?"),
  dateRangeInput("holiday", "When do you want to go on vacation next?")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)