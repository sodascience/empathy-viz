source("questions.R")
visDatasetUI <- function(id) {
  tagList(
    h4("Selecteer een dataset om te visualiseren"),
    radioButtons(NS(id,"dataset_radio"), "Datasets:",
                 c("Huidig onderzoek" ="current",
                   "Een bestand uploaden" = "file" )),
    fileInput(NS(id,"file1"), "Kies een CSV-bestand:", accept = ".csv"),
    
    # Action button Visualize
    actionButton(NS(id,"OK.button"), "OK")
    #h5(textOutput(NS(id,"Message"), container = span))
    #tableOutput(NS(id,"contents"))
  )
}

visDatasetServer <- function(id, df.survey, df.vis) {
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
      validate(need(ext == "csv", "Upload a.u.b. een csv-bestand"))
      df <- read.csv(file$datapath)
      df$relatie <- factor(df$relatie, levels = c("vriend","vreemde","vijand") )
      df$emotie <- factor(df$emotie, levels = c("empathie","sympathie","distress","gedrag","counter"))
      df$vign_cat <- factor(df$vign_cat, levels = c("blijdschap","pijn","verdriet") )
      df$vignet <- factor(df$vignet)
      return (df)
    }, ignoreNULL = FALSE)
 
    
    user_choice <- observeEvent(input$OK.button,{ #
      if(input$dataset_radio=="file"){
        df.vis$data <- select_file()
      }else{
        df.vis$data <- refactor_df(df.survey$data)
      }
      ## use ignoreNULL to fire the event at startup
    }, ignoreNULL = FALSE) 
    
})
}
