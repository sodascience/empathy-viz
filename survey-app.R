# This file is part of Empathy-viz.

# Copyright (C) 2024  Minet de Wied & SodaScience

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

library(shiny)
library(shinyjs)
source("mod-disclaimer.R")
source("mod-question.R")
source("mod-image.R")
source("mod-input.R")
source("questions.R")
source("mod-visDataset.R")
source("mod-visRelationship.R")
source("mod-visEmotions.R")
source("mod-visRelEmo.R")

ui <- navbarPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  id = "main.navbar",
  title = "Empathie in Beeld",
  shinyjs::useShinyjs(),
  
  # Disclaimer-tab
  tabPanel(
    "Disclaimer",
    wellPanel(
      disclaimerUI("dsc1")
    )
  ),
  
  # Input-tab
  tabPanel(
    title = "Input",
    value = "input_tab",
    wellPanel(
      style = "min-width: 300px;max-width: 400px;overflow:auto",
      verticalLayout(
        inputUI("inp1")
      )
    )
  ),
  
  # Questionnaire-tab
  tabPanel(
    title = "Vragenlijst",
    value = "tvrag",
    sidebarLayout(
      sidebarPanel(
        imageUI("img1"),
        width = 3
      ),
      mainPanel(
        questionUI("surv1"),
        width = 9
      )
    )
  ),
  
  # Visualization-tab
  tabPanel(
    "Visualisatie",
    tabsetPanel(
      id = "vistab",
      tabPanel(
        title = "Selecteer Dataset",
        value = "tdataset",
        visDatasetUI("visDataset1")
      ),
      navbarMenu(
        "Dynamiek in relaties",
        tabPanel(
          title = "Blijdschap",
          value = "tblij",
          visRelationshipUI("visRelationship2")
        ),
        tabPanel(
          title = "Verdriet",
          value = "tverd",
          visRelationshipUI("visRelationship3")
        ),
        tabPanel(
          title = "Pijn",
          value = "tpijn",
          visRelationshipUI("visRelationship1")
        )
      ),
      tabPanel(
        "Relaties * Emoties",
        visRelEmoUI("visRelEmo1")
      ),
      tabPanel(
        title = "Dynamiek in emoties",
        value = "temo",
        visEmotionUI("visEmotion1")
      )
    )
  )
)

server <- function(input, output, session) {
  counter <- reactiveVal(0)
  input.data <- reactiveValues(gender = NULL, age = NULL, code = NULL)
  df.survey <- reactiveValues(data = NULL)
  df.vis <- reactiveValues(data = NULL)
  disclaimer_file_path = "data/disclaimer.csv"
  questionServer("surv1", "data/introduction.csv","data/vignettes.csv",
                 "data/relationships.csv", "data/RadioMatrixFrame.csv",
                 "data/ending.csv",counter,input.data,df.survey)
  imageServer("img1","data/vignettes.csv",counter)
  inputServer("inp1",input.data, session, "main.navbar","tvrag")
  disclaimerServer("dsc1",session , "main.navbar","input_tab", disclaimer_file_path)
  visDatasetServer("visDataset1",df.survey, df.vis, session,"vistab","tblij")
  visRelationshipServer("visRelationship1",df.vis,"data/vignettes.csv","data/guideline_vis.csv",'pijn')
  visRelationshipServer("visRelationship2",df.vis,"data/vignettes.csv","data/guideline_vis.csv",'blijdschap')
  visRelationshipServer("visRelationship3",df.vis,"data/vignettes.csv","data/guideline_vis.csv",'verdriet')
  visEmotionServer("visEmotion1","data/guideline_vis.csv",df.vis)
  visRelEmoServer("visRelEmo1","data/guideline_vis.csv",df.vis)
  
  # Disable all tabs except Disclaimer initially
  shinyjs::disable(selector = "#main\\.navbar li a[data-value='input_tab']")
  shinyjs::disable(selector = "#main\\.navbar li a[data-value='tvrag']")
  shinyjs::disable(selector = "#main\\.navbar li a[data-value='tdataset']")
  shinyjs::disable(selector = "#main\\.navbar li a[data-value='tblij']")
  shinyjs::disable(selector = "#main\\.navbar li a[data-value='tverd']")
  shinyjs::disable(selector = "#main\\.navbar li a[data-value='tpijn']")
  shinyjs::disable(selector = "#main\\.navbar li a[data-value='temo']")
}

shinyApp(ui, server)