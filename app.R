#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(navbarPage(theme = bslib::bs_theme(bootswatch = "flatly"),
                 # Application title
                 "Empathy Survey",
                 tabPanel(
                   "Input",
                   wellPanel(
                     style= "min-width: 300px;max-width: 400px;overflow:auto",
                     verticalLayout(
                       h4("Background information"),
                       textInput("Gender", placeholder = "Gender", label = "Gender:", width = "30%"),
                       textInput("Age", placeholder = "Age", label = "Age:", width = "30%"),
                       textInput("Code", placeholder = "Code", label = "Code:", width = "30%"),
                       submitButton("Submit")
                   )
                 )),
                 tabPanel("Questionnair"),
                 tabPanel("Results")
))


# Define server logic required to draw a histogram
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)