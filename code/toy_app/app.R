library(shiny)
library(rsconnect)

ui <- fluidPage(
  textInput("entry", "Enter your name please", placeholder = "Name"),
  textOutput("message")
)

server <- function(input, output, session) {
  output$message <- renderText(paste0("Hello ", input$entry, "!"))
}

shinyApp(ui, server)