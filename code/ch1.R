library(shiny)

# Exercises --------------------------------------------------------------------
## 1 ----
ui <- fluidPage(
    textInput("name", label = "What is your name?", value = NA),
    textOutput("greeting")
)

server <- function(input, output, session) {
    output$greeting <- renderPrint({
        cat("Greetings ", input$name, "!", sep = "")
    })
    
}

shinyApp(ui = ui, server = server)


## 2 ----
ui <- fluidPage(
    sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
    "then x times 5 is",
    textOutput("product")
)

server <- function(input, output, session) {
    output$product <- renderText({
        input$x * 5
    })
}

shinyApp(ui = ui, server = server)


## 3 ----
ui <- fluidPage(
    sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
    sliderInput("y", label = "and y is", min = 1, max = 50, value = 5),
    "then x times y is",
    textOutput("product")
)

server <- function(input, output, session) {
    output$product <- renderText({
        input$x * input$y
    })
}

shinyApp(ui = ui, server = server)


## 4 ----
ui <- fluidPage(
    sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
    sliderInput("y", label = "and y is", min = 1, max = 50, value = 5),
    "then (x * y) is", textOutput("product"),
    "(x * y) + 5 is", textOutput("product_plus5"),
    "and (x * y) + 10 is", textOutput("product_plus10")
)

server <- function(input, output, session) {
    xy <- reactive({
        input$x * input$y
    })
    
    output$product <- renderText({
        xy()
    })
    
    output$product_plus5 <- renderText({
        xy() + 5
    })
    
    output$product_plus10 <- renderText({
        xy() + 10
    })
}

shinyApp(ui = ui, server = server)


## 5 ----
library(ggplot2)

datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
    selectInput("dataset", label = "Dataset", choices = datasets),
    verbatimTextOutput("summary"),
    plotOutput("plot")
)

server <- function(input, output, session) {
    dataset <- reactive({
        get(input$dataset, "package:ggplot2")
    })
    
    output$summary <- renderPrint({
        summary(dataset())
    })
    
    output$plot <- renderPlot({
        plot(dataset())
    },
    res=96)
}

shinyApp(ui, server)