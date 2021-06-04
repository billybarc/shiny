library(shiny)

# 2.2 Inputs ----
# 1
ui <- fluidPage(
  textInput("name", "", placeholder = "Your name")
)

server <- function(input, output, session) {
}

shinyApp(ui, server)


# 2
ui <- fluidPage(
  sliderInput("date", "When should we deliver?", 
              min = as.Date("2020-09-16"),
              max = as.Date("2020-09-23"),
              value = as.Date("2020-09-17"))
)

server <- function(input, output, session) {
}

shinyApp(ui, server)


# 3
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


# 4
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


# 2.3 Outputs ----
# 1
ui <- fluidPage(
  verbatimTextOutput("car_sum"),
  textOutput("alarm"),
  verbatimTextOutput("test"),
  verbatimTextOutput("str_model")
)

server <- function(input, output, session) {
  output$car_sum <- renderPrint(summary(mtcars))
  
  output$alarm <- renderText("Good morning!")
  
  output$test <- renderPrint(t.test(1:5, 2:6))
  
  # this is renderText in the book, but I couldn't get this to print in the
  # app rather than the console. Switched to renderPrint. I think this boils
  # down to str() already being like cat().
  output$str_model <- renderPrint(str(lm(mpg ~ wt, data = mtcars)))
}

shinyApp(ui, server)


# 2
ui <- fluidPage(
  plotOutput("plot", width = "700px", height = "300px")
)

server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5), res = 96,
                            alt = "Scatterplot of the numbers one through five.")
}

shinyApp(ui, server)


# 3
ui <- fluidPage(
  dataTableOutput("table")
)

server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, 
                                  options = list(pageLength = 5,
                                                 info = F,
                                                 ordering = F,
                                                 searching = T))
}

shinyApp(ui, server)


# 4
# sounds like DT with server-side rendering is recommended for larger tables. 
# Default Shiny DataTables are all server-side. DT package allows server- and
# client-side DataTables.
# reactable is all client-side (for now, see github issue below)
# https://github.com/glin/reactable/issues/22
ui <- fluidPage(
  reactable::reactableOutput("rtable")
)

server <- function(input, output, session) {
  output$rtable <- reactable::renderReactable(reactable::reactable(
    mtcars,
    sortable = F,
    # searchable FALSE by default
    searchable = F,
    showPageInfo = F))
}

shinyApp(ui, server)