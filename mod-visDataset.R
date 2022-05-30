source("questions.R")
library("readxl")
library("tidyr")
library("dplyr")

visDatasetUI <- function(id) {
  tagList(
    h4("Selecteer een dataset om te visualiseren"),
    radioButtons(NS(id,"dataset_radio"), "Datasets:",
                 c("Huidig onderzoek" ="current",
                   "Een bestand uploaden" = "file" )),
    fileInput(NS(id,"file1"), "Kies een CSV or XLSX-bestand:", accept = c(".csv",".xlsx")),
    
    # Action button Visualize
    actionButton(NS(id,"OK.button"), "OK")
    #h5(textOutput(NS(id,"Message"), container = span))
    #tableOutput(NS(id,"contents"))
  )
}

visDatasetServer <- function(id, df.survey, df.vis, parrent.session, tabset.id, tab.target) {
  moduleServer(id, function(input, output, session) {
  
    
    drv <-  observeEvent(input$dataset_radio,{
      # show/hide browse button
      if(input$dataset_radio=="current"){
        shinyjs::hide(id = "file1")
      }else{
        shinyjs::show(id = "file1")
      }
    })
    
    select_file <-  eventReactive(input$file1,{
      file <- input$file1
      ext <- tools::file_ext(file$datapath)
      req(file)
      if (ext == "csv") {
        df <- read.csv(file$datapath)
        df$relatie <- factor(df$relatie, levels = c("vriend(in)","vreemde","vijand") )
        df$respons <- factor(df$respons, levels = c("empathie","counter","distress","sympathie","gedrag"))
        df$vign_cat <- factor(df$vign_cat, levels = c("blijdschap","pijn","verdriet") )
        df$vignet <- factor(df$vignet)
      } else if (ext == "xlsx") {
        df <- readxl::read_excel(file$datapath)
        df$relatie <- factor(df$relatie, levels = c("vriend(in)","vreemde","vijand") )
        df$respons <- factor(df$respons, levels = c("empathie","counter","distress","sympathie","gedrag"))
        df$vign_cat <- factor(df$vign_cat, levels = c("blijdschap","pijn","verdriet") )
        df$vignet <- factor(df$vignet)
      } else {
        need(FALSE, "Upload a.u.b. een csv or xlsx-bestand")
      }
      #validate(need(ext == "csv", "Upload a.u.b. een csv-bestand"))
      
      return (df)
    }, ignoreNULL = FALSE)
 
    
    select.dataset <- eventReactive(input$OK.button,{
      if(input$dataset_radio=="file"){
        df.vis$data <- select_file()
      }else{
        df.vis$data <- refactor_df(df.survey$data)
      }
      df.vis$data
    })
      
    user_choice <- observeEvent(input$OK.button,{ #
      # if(input$dataset_radio=="file"){
      #   df.vis$data <- select_file()
      # }else{
      #   df.vis$data <- refactor_df(df.survey$data)
      # }
      # 
      req(select.dataset())
      updateTabsetPanel(parrent.session, tabset.id,
                          selected = tab.target)
      
      ## use ignoreNULL to fire the event at startup
    }, ignoreNULL = FALSE) 
    
})
}
