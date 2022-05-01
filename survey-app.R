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
                           id = "main.navbar",
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
                             title = "Vragenlijst",
                             value = "tvrag",
                             
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
                             id = "vistab",
                             tabPanel(title = "DataSet",
                                      value = "tdataset",
                                      visDatasetUI("visDataset1")
                             ),
                             tabPanel(title = "Dynamiek in emoties",
                                      value = "temo",
                                      visEmotionUI("visEmotion1")
                             ),
                             navbarMenu("Dynamiek in relaties",
                                        tabPanel(title = "Blijdschap", 
                                                 value = "tblij",
                                                 visRelationshipUI("visRelationship2")),
                                        tabPanel(title = "Verdriet",
                                                 value = "tverd",
                                                 visRelationshipUI("visRelationship3")),
                                        tabPanel(title = "Pijn",
                                                 value = "tpijn",
                                                 visRelationshipUI("visRelationship1"))
                                      
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
  inputServer("inp1",input.data, session, "main.navbar","tvrag")
  visDatasetServer("visDataset1",df.survey, df.vis, session,"vistab","temo")
  visRelationshipServer("visRelationship1",df.vis,"data/vignettes.csv","data/guideline_vis.csv",'pijn')
  visRelationshipServer("visRelationship2",df.vis,"data/vignettes.csv","data/guideline_vis.csv",'blijdschap')
  visRelationshipServer("visRelationship3",df.vis,"data/vignettes.csv","data/guideline_vis.csv",'verdriet')
  visEmotionServer("visEmotion1","data/guideline_vis.csv",df.vis)
  visRelEmoServer("visRelEmo1","data/guideline_vis.csv",df.vis)
}
shinyApp(ui, server)
