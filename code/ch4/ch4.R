library(shiny)

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

# 4.8 Exercises ----
# 1 ----
# See png in parent directory

# 2 ----