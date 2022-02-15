library(shiny)
source("mod-question.R")
source("mod-image.R")
source("mod-input.R")
source("questions.R")
source("mod-visDataset.R")
source("mod-visRelationship.R")
source("mod-visEmotions.R")
source("mod-visRelEmo.R")

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
                           
                           # Start Visualization-tab
                         tabPanel(
                           "Visualization",
                           tabsetPanel(
                             tabPanel("DataSet",
                                      visDatasetUI("visDataset1")
                             ),
                             tabPanel("Relationship",
                                      visRelationshipUI("visRelationship1")
                             ),
                             tabPanel("Emotions",
                                      visEmotionUI("visEmotion1")
                             ),
                             tabPanel("Relationship_Emotions",
                                      visRelEmoUI("visRelEmo1"))
                           ))
                          # End Visualization-tab 
                   
)
server <- function(input, output, session) {
  counter <- reactiveVal(0)
  input.data <- reactiveValues(gender = NULL, age = NULL, code = NULL)
  df.survey <- reactiveValues(data = NULL, current = NULL)
  
  questionServer("surv1", "data/introduction.csv","data/vignettes.csv",
                 "data/relationships.csv", "data/RadioMatrixFrame.csv",
                 counter,input.data,df.survey)
  imageServer("img1","data/vignettes.csv",counter)
  inputServer("inp1",input.data)
  visDatasetServer("visDataset1",df.survey)
  visRelationshipServer("visRelationship1",df.survey)
  visEmotionServer("visEmotion1",df.survey)
  visRelEmoServer("visRelEmo1",df.survey)
}
shinyApp(ui, server)
