library(shiny)
source("mod-question.R")
source("mod-image.R")
source("mod-input.R")
source("questions.R")

ui <- navbarPage(theme = bslib::bs_theme(bootswatch = "flatly"),
                           # Application title
                           "Empathy Survey",
                            shinyjs::useShinyjs(),
                           
                           # Start Input-tab
                           tabPanel(
                             "Input",
                             
                             # Input-tab body
                             wellPanel(
                               style= "min-width: 300px;max-width: 400px;overflow:auto",
                               verticalLayout(
                                 inputUI("inp1")
                               )
                              )
                             ),
                            # End Input-tab
                           
                           
                           # Start Questionnaire-tab
                           tabPanel(
                             "Questionnaire",
                             
                             sidebarLayout(
                               sidebarPanel(
                                 imageUI("img1")
                               ),
                               
                               mainPanel(
                                 questionUI("surv1")   
                               )
                             )
                           ),
                          # End Questionnaire-tab 
                           
                        # Start Visualization-tab with sub-menu
                        navbarMenu("Visualization",
                                  tabPanel("Pijn"),
                                  tabPanel("Verdrietig"),
                                  tabPanel("Blij"))
                   
                        # End Visualization-tab
                   
)
server <- function(input, output, session) {
  input.data <- reactiveValues(gender = NULL, age = NULL, code = NULL)
  counter <- reactiveVal(0) 
  df.survey <- reactiveValues(data = NULL, current = NULL)
  
  
  questionServer("surv1", "data/introduction.csv","data/vignettes.csv",
                 "data/relationships.csv","data/RadioMatrixFrame.csv",counter,input.data)
  imageServer("img1","data/vignettes.csv",counter)
  inputServer("inp1",input.data)
}
shinyApp(ui, server)
