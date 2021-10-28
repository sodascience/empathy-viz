library(shiny)

# Define UI for application that draws a histogram
shinyUI(navbarPage(theme = bslib::bs_theme(bootswatch = "flatly"),
                           # Application title
                           "Empathy Survey",
                           
                           # First menu entry
                           tabPanel(
                             "Input",
                             
                             # First menu body
                             wellPanel(
                               style= "min-width: 300px;max-width: 400px;overflow:auto",
                               verticalLayout(
                                 h4("Background information"),
                                 textInput("Gender", placeholder = "Gender", label = "Gender:", width = "30%"),
                                 textInput("Age", placeholder = "Age", label = "Age:", width = "30%"),
                                 textInput("Code", placeholder = "Code", label = "Code:", width = "30%"),
                                 actionButton("OK.Input", "OK")
                               )
                             )),
                           
                           
                           # Second menu entry
                           tabPanel(
                             "Questionnair",
                             
                             # Second menu body
                             sidebarLayout(
                               sidebarPanel(
                                 p("Vraag 1 - pijn"),
                                 p("Vraag 2 - blijheid"),
                                 p("Vraag 3 - droefheid"),
                                 p("Vraag 4 - pijn"),
                                 p("Vraag 5 - blijheid"),
                                 p("Vraag 6 - droefheid")
                                 
                               ),
                               
                               mainPanel(
                                 # Main Action is where most everything is happenning in the
                                 # object (where the welcome message, survey, and results appear)
                                 uiOutput("MainAction"),
                                 # This displays the action putton Next.
                                 actionButton("Click.Counter", "Next")    
                               )
                             )
                             
                           ),
                           
                           
                           # Third menu with sub-menu
                           navbarMenu("Visualization",
                                      tabPanel("Pijn"),
                                      tabPanel("Verdrietig"),
                                      tabPanel("Blij"))
))
