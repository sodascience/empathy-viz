source("questions.R")
inputUI <- function(id) {
  tagList(
    h4("Background information"),
    textInput(NS(id,"Gender"), placeholder = "Gender", label = "Gender:", width = "30%"),
    textInput(NS(id,"Age"), placeholder = "Age", label = "Age:", width = "30%"),
    textInput(NS(id,"Code"), placeholder = "Code", label = "Code:", width = "30%"),
    actionButton(NS(id,"OK.Input"), "OK")
  )
}

inputServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    })
}

