library(shiny)


# 6.2.4 ----

# fluidRow()s and column()s to use Bootstrap grid system
# Multiple pages (through tabsets and navbars) with
# tabsetPanel()/tabPanel() (horizontal tabs),
# navlistPanel() (vertical tabs), and
# navbarPage()/navbarMenu() (horizontal, with dropdowns)

# |_ # 1 ----

# sidebarPanel width = 2/3 of page.
# Can recreate widths with column()s and fluidRow,
# but not the colored background of the sidebarPanel().

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("letter", "Pick a letter!", choices = letters, selected = "a")
    ),
    mainPanel(
      textOutput("message")
    )
  )
)

server <- function(input, output, session) {
  output$message <- renderText(paste0("You picked ", input$letter, 
                                      ", wow, what a great letter!"))
}

shinyApp(ui, server)

ui <- fluidPage(
  fluidRow(
    column(4,
           selectInput("letter", "Pick a letter!", choices = letters, selected = "a")),
    column(8,
           textOutput("message"))
  )
)

shinyApp(ui, server)

# |_ # 2 ----

ui <- fluidPage(
  titlePanel("Central limit theorem"),
  sidebarLayout(
    mainPanel(
      plotOutput("hist")
    ),
    sidebarPanel(
      numericInput("m", "Number of samples:", 2, min = 1, max = 100)
    )
  )
)

server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui, server)

# |_ # 3 ----

ui <- fluidPage(
  fluidRow(
    column(6,
           plotOutput("plot1")),
    column(6,
           plotOutput("plot2")
    )),
  fluidRow(
    
    column(6,
           numericInput("sample_size", "Sample size (# of samples = 10000)", 1, 100)),
    column(6,
           numericInput("no_of_samples", "# of samples (sample size = 50)", 10, 10000))
  )
)

server <- function(input, output, session) {
  output$plot1 <- renderPlot({
    means1 <- replicate(1e4, mean(runif(input$sample_size)))
    hist(means1, breaks = 20)
  })
  
  output$plot2 <- renderPlot({
    means2 <- replicate(input$no_of_samples, 
                        mean(runif(50)))
    hist(means2, breaks = 20)
  })
}

shinyApp(ui, server)

# 6.5.4 ----

# bs_theme() to customize theme
# bs_theme_preview() to mess about interactively

# |_ # 1

library(bslib)

bs_theme_preview(bs_theme(
  bg = "#522f2f",
  fg = "#eb65d4",
  primary = "#b59628",
  base_font = font_google("Lobster Two")
)
)
