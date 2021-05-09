library(shiny)

# <section>.<exercise #>
# 2.1 ----
ui <- fluidPage(
  textInput("name", "", placeholder = "Your name")
)

server <- function(input, output, session) {
}

shinyApp(ui, server)


# 2.2 ----
ui <- fluidPage(
  sliderInput("date", "When should we deliver?", 
              min = as.Date("2020-09-16"),
              max = as.Date("2020-09-23"),
              value = as.Date("2020-09-17"))
)

server <- function(input, output, session) {
}

shinyApp(ui, server)


# 2.3 ----
ui <- fluidPage(
  sliderInput("value", "", 
              min = 0,
              max = 100,
              value = 0,
              step = 5, 
              animate = TRUE)
)

server <- function(input, output, session) {
}

shinyApp(ui, server)


# 2.4 ----
ui <- fluidPage(
  selectInput("state", "Choose a state", 
              choices = split(datasets::state.name, 
                              datasets::state.region)),
  textOutput("message")
)

server <- function(input, output, session) {
  output$message <- renderText({
    paste0("You have chosen the great state of ", input$state, "!")
  })
}

shinyApp(ui, server)
