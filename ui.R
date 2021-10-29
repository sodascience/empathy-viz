

library(shiny)


shinyUI(navbarPage(theme = bslib::bs_theme(bootswatch = "flatly"),
                           # Application title
                           "Empathy Survey",
                           
                           # Start Input-tab
                           tabPanel(
                             "Input",
                             
                             # Input-tab body
                             wellPanel(
                               style= "min-width: 300px;max-width: 400px;overflow:auto",
                               verticalLayout(
                                 h4("Background information"),
                                 textInput("Gender", placeholder = "Gender", label = "Gender:", width = "30%"),
                                 textInput("Age", placeholder = "Age", label = "Age:", width = "30%"),
                                 textInput("Code", placeholder = "Code", label = "Code:", width = "30%"),
                                 actionButton("OK.Input", "OK")
                               )
                              )
                             ),
                            # End Input-tab
                           
                           
                           # Start Questionnaire-tab
                           tabPanel(
                             "Questionnaire",
                             
                             # Progress bar
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
                                 uiOutput("MainAction"),
                                 
                                 # Action button Next
                                 actionButton("Click.Counter", "Next")    
                               )
                             )
                           ),
                          # End Questionnaire-tab 
                           
                           # Start Visualization-tab with sub-menu
                           navbarMenu("Visualization",
                                      tabPanel("Pijn"),
                                      tabPanel("Verdrietig"),
                                      tabPanel("Blij"))
                          # End Questionnaire-tab 
                   
))
