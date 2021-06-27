library(shiny)
library(tidyverse)
library(ggplot2)
library(vroom)

# Get data
dir.create("./code/ch4/neiss")
#> Warning in dir.create("neiss"): 'neiss' already exists
download <- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
  download.file(paste0(url, name), paste0("./code/ch4/neiss/", name), quiet = TRUE)
}
download("injuries.tsv.gz")
download("population.tsv")
download("products.tsv")

injuries <- vroom::vroom("./code/ch4/neiss/injuries.tsv.gz")
products <- vroom::vroom("./code/ch4/neiss/products.tsv")
population <- vroom::vroom("./code/ch4/neiss/population.tsv")

prod_codes <- setNames(products$prod_code, products$title)

# 4.8 Exercises ----
# 1 ----
# See png in parent directory

# 2 ----
# fct_infreq reorders factor levels by their frequency.
# When inside, it makes sure the levels that are not lumped from the output of
# fct_lump are in descending order of frequency in the data. Because
# Other is likely to be one of the largest categories after lumping,
# running fct_infreq after fct_lump will result in Other possibly being
# earlier (if not first) in the ordering of factor levels.

foo <- as.factor(c("b",
                   rep("a", 2),
                   rep("c", 3),
                   rep("d", 2),
                   rep("e", 5)))
foo

fct_lump(fct_infreq(foo), n = 2)
fct_infreq(fct_lump(foo, n = 2))

# 3 ----
count_top <- function(df, var, n) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", choices = prod_codes)
    ),
    column(6,
           sliderInput("rows", 
                       "# of table rows", 
                       value = 5, 
                       min = 1, 
                       max = length(prod_codes),
                       step = 1))
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  # - 1 because n in count_top is how many levels to preserve
  nrows <- reactive(input$rows - 1) 
  
  
  output$diag <- renderTable(count_top(selected(), diag, nrows()), 
                             width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part, nrows()), 
                                  width = "100%")
  output$location <- renderTable(count_top(selected(), location, nrows()), 
                                 width = "100%")
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  }, res = 96)
}

shinyApp(ui, server)

# 4 ----
# I implemented scrolling through narratives by adding two action buttons,
# I combine their values (action buttones initialize to 0
# and increment with clicks) and make sure negative values 
# (too many left button clicks) result in 1 (don't fall off the edge) and
# I use modulo (%%) to make sure too many right clicks cycles back 
# around to the first element. This requires accessing the length of
# selected()'s narrative column vector, which might be poor style or an 
# unnecessary dependency. The ifelse logic is done inside a reactive, which
# is used in the renderText call to create the output. 
# I don't think a reactive is actually necessary here,
# as I tested pasting the calculation logic in the place of the reactive
# variable (within parentheses) and the app worked fine. I'm not sure if it
# is good practice to use reactives to clean up code like this.
#
# It would be nice to reset the clicker values based on events. 
# For example, if the user clicks left too many times,
# they are alerted and the left button counter remains at 0. 
# I'll likely learn the functionality that would enable this later in the book.

# It would also be nice to reset the index to 1
# if the user selects another product. This likely would involve
# moving away from using the active values of
# the radio buttons for the index value (unless, like mentioned
# in the last paragraph, I can reset the counters themselves).

# I saw a solution that uses a reactiveVal() to track
# the state of the narrative index. This allows one to
# break up the logic of adjusting it (on updated product code AND on
# button clicks) into individual observeEvent calls. I'm not sure
# I'm supposed to know what reactiveVals are yet though (seems to enter
# in chapter 15).
ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", choices = prod_codes)
    ),
    column(6,
           sliderInput("rows", 
                       "# of table rows", 
                       value = 5, 
                       min = 1, 
                       max = length(prod_codes),
                       step = 1))
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  fluidRow(
    column(2, actionButton("left", "Previous", icon("arrow-left"))),
    column(2, actionButton("right", "Next", icon("arrow-right"))),
    column(8, textOutput("narrative"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  # - 1 because n in count_top is how many levels to preserve
  nrows <- reactive(input$rows - 1) 
  
  output$diag <- renderTable(count_top(selected(), diag, nrows()), 
                             width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part, nrows()), 
                                  width = "100%")
  output$location <- renderTable(count_top(selected(), location, nrows()), 
                                 width = "100%")
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  }, res = 96)
  
  idx_val <- reactive({
    if (input$right - input$left < 0) {
      1
    } else {
      (input$right - input$left) %% length(selected()$narrative) + 1
    }
  })
  
  output$narrative <- renderText(paste0(
    idx_val(), " of ", length(selected()$narrative), 
    ": ", selected()$narrative %>% .[idx_val()]))
}

shinyApp(ui, server)
