library(shiny)
library(ggplot2)

freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
  df <- data.frame(
    x = c(x1, x2),
    g = c(rep("x1", length(x1)), rep("x2", length(x2)))
  )
  
  ggplot(df, aes(x, colour = g)) +
    geom_freqpoly(binwidth = binwidth, size = 1) +
    coord_cartesian(xlim = xlim)
}

t_test <- function(x1, x2) {
  test <- t.test(x1, x2)
  
  # use sprintf() to format t.test() results compactly
  sprintf(
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2]
  )
}

ui <- fluidPage(
  fluidRow(
    column(
      4, "Distribution 1",
      numericInput("n1", label = "n", value = 1000, min = 1),
      numericInput("mean1", label = "μ", value = 0, step = 0.1),
      numericInput("sd1", label = " ", value = 0.5, min = 0.1, step = 0.1)
    ),
    column(
      4, "Distribution 2",
      numericInput("n2", label = "n", value = 1000, min = 1),
      numericInput("mean2", label = "μ", value = 0, step = 0.1),
      numericInput("sd2", label = " ", value = 0.5, min = 0.1, step = 0.1)
    ),
    column(
      4, "Frequency polygon",
      numericInput("binwidth", label = "Bin width", value = 0.1, step = 0.1),
      sliderInput("range", label = "range", value = c(-3, 3), min = -5, max = 5)
    )
  ),
  fluidRow(
    column(9, plotOutput("hist")),
    column(3, verbatimTextOutput("ttest"))
  ),
  
  fluidRow(
    column(3,
           numericInput("lambda1", label = "lambda1", value = 3),
           numericInput("lambda2", label = "lambda2", value = 5),
           numericInput("n", label = "n", value = 1e4, min = 0),
    ),
    column(9, plotOutput("hist1"))
  ),
  
  fluidRow(
    column(3,
           numericInput("lambda3", label = "lambda3", value = 3),
           numericInput("lambda4", label = "lambda4", value = 5),
           numericInput("number", label = "n", value = 1e4, min = 0),
           actionButton("simulate", "Simulate")
    ),
    column(9, plotOutput("hist2"))
  )
)

server <- function(input, output,session) {
  x1 <- reactive(rnorm(input$n1, input$mean1, input$sd1))
  x2 <- reactive(rnorm(input$n2, input$mean2, input$sd2))
  
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = input$binwidth, xlim = input$range)
  }, res = 96)
  
  output$ttest <- renderText({
    t_test(x1(), x2())
  })
  
  timer <- reactiveTimer(500)
  x3 <- reactive({
    timer()
    rpois(input$n, input$lambda1)
  })
  x4 <- reactive({
    timer()
    rpois(input$n, input$lambda2)
  })
  
  output$hist1 <- renderPlot({
    freqpoly(x3(), x4(), binwidth = 1, xlim = c(0, 40))
  })
  
  
  x5 <- eventReactive(input$simulate, {
    rpois(input$number, input$lambda3)
  })
  x6 <- eventReactive(input$simulate,{
    rpois(input$number, input$lambda4)
  })
  
  output$hist2 <- renderPlot({
    freqpoly(x5(), x6(), binwidth = 1, xlim = c(0, 40))
  })
}

shinyApp(ui, server)