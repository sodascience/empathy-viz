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
                           "Empathie in Beeld",
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
                             "Vragenlijst",
                             
                             # Progress bar
                             sidebarLayout(
                               sidebarPanel(
                                 imageUI("img1"),
                                 width = 3
                                 
                               ),
                               
                               mainPanel(
                                 questionUI("surv1") ,
                                 width = 9
                               )
                             )
                           ),
                          # End Questionnaire-tab 
                           
                           # Start Visualization-tab
                         tabPanel(
                           "Visualisatie",
                           tabsetPanel(
                             tabPanel("DataSet",
                                      visDatasetUI("visDataset1")
                             ),
                             
                             navbarMenu("Dynamiek in relaties",
                                        tabPanel("Blijdschap",visRelationshipUI("visRelationship2")),
                                        tabPanel("Verdriet",visRelationshipUI("visRelationship3")),
                                        tabPanel("Pijn",visRelationshipUI("visRelationship1"))
                                      
                             ),
                             tabPanel("Dynamiek in emoties",
                                      visEmotionUI("visEmotion1")
                             ),
                             tabPanel("Relaties X Emoties",
                                      visRelEmoUI("visRelEmo1"))
                           ))
                          # End Visualization-tab 
                   
)
server <- function(input, output, session) {
  counter <- reactiveVal(0)
  input.data <- reactiveValues(gender = NULL, age = NULL, code = NULL)
  df.survey <- reactiveValues(data = NULL)
  df.vis <- reactiveValues(data = NULL)
  
  questionServer("surv1", "data/introduction.csv","data/vignettes.csv",
                 "data/relationships.csv", "data/RadioMatrixFrame.csv",
                 "data/ending.csv",counter,input.data,df.survey)
  imageServer("img1","data/vignettes.csv",counter)
  inputServer("inp1",input.data)
  visDatasetServer("visDataset1",df.survey, df.vis)
  visRelationshipServer("visRelationship1",df.vis,'pijn')
  visRelationshipServer("visRelationship2",df.vis,'blijdschap')
  visRelationshipServer("visRelationship3",df.vis,'verdriet')
  visEmotionServer("visEmotion1",df.vis)
  visRelEmoServer("visRelEmo1",df.vis)
}
shinyApp(ui, server)
