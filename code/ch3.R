library(shiny)

# 3.3 Reactive programming ------------------------------------------------
# 1
ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

# # original
# server1 <- function(input, output, server) {
#   input$greeting <- renderText(paste0("Hello ", name))
# }
# 
# server2 <- function(input, output, server) {
#   greeting <- paste0("Hello ", input$name)
#   output$greeting <- renderText(greeting)
# }
# 
# server3 <- function(input, output, server) {
#   output$greting <- paste0("Hello", input$name)
# }

# name is within the input list
# greeting is in the output list
server1 <- function(input, output, server) {
  output$greeting <- renderText(paste0("Hello ", input$name))
}

# make greeting a reactive if must be two lines
server2 <- function(input, output, server) {
  greeting <- reactive(paste0("Hello ", input$name))
  output$greeting <- renderText(greeting())
}

# spelling error and no reactive/render 
# could also use a space in paste0 or just change to paste
server3 <- function(input, output, server) {
  output$greeting <- renderText(paste("Hello", input$name))
}

shinyApp(ui, server3)


# 2
# draw reactive graphs
# server1 <- function(input, output, session) {
#   c <- reactive(input$a + input$b)
#   e <- reactive(c() + input$d)
#   output$f <- renderText(e())
# }
#      |a
#        \
# |b> -> >c> -> >e> -> >f|
#               /
#             |d>

# server2 <- function(input, output, session) {
#   x <- reactive(input$x1 + input$x2 + input$x3)
#   y <- reactive(input$y1 + input$y2)
#   output$z <- renderText(x() / y())
# }
#          |x2> |x3>
#             \  /
#      |x1> - >x> 
#              |
# |y1> - >y>  >z|
#        /
#     |y2>

# server3 <- function(input, output, session) {
#   d <- reactive(c() ^ input$d)
#   a <- reactive(input$a * 10)
#   c <- reactive(b() / input$c)
#   b <- reactive(a() + input$b)
# }
# no output, so code is never run? footnote
# 10 suggests as much


# 3

# why will this fail?
# var <- reactive(df[[input$var]])
# range <- reactive(range(var(), na.rm = TRUE))

# Output list is never written to? Otherwise, I see no reason
# why this should fail. I've tested it below and it seems
# to work fine.

df <- mtcars
ui <- fluidPage(
  selectInput("var", "Pick a variable",
              names(df)),
  textOutput("range")
)

server <- function(input, output, session) {
  var <- reactive(df[[input$var]])
  output$range <- reactive((range(var(), na.rm = T)))
}
 
shinyApp(ui, server)

# Why are range() and var() bad names for reactive?

# range and var are names of functions from base packages, best
# to avoid possibly confusing names. The server function environment
# appears to take precedence, not sure how you'd specify
# that you actually want the var() or range() functions.

# No more exercises for rest of chapter. Cool content
# on how reactive()s can help you update once and reuse 
# updated variables, reactiveTimer() and eventReactive()
# to hone in on when reactive()s are updated, and 
# observers for reactive triggers that run code
# but don't update UI output elements.