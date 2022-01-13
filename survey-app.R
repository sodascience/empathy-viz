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
                             
                             # Progress bar
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
                          # End Questionnaire-tab 
                   
)
server <- function(input, output, session) {
  counter <- reactiveVal(0) 
  
  questionServer("surv1", "data/introduction.csv","data/situations.csv","data/sub_situations.csv","data/RadioMatrixFrame.csv",counter)
  imageServer("img1","data/situations.csv",counter)
  inputServer("inp1")
}
shinyApp(ui, server)
