visDatasetUI <- function(id) {
  tagList(
    h4("Select a dataset to visualize"),
    radioButtons(NS(id,"dataset_radio"), "Datasets:",
                 c("Current servey" ="current",
                   "Upload a File" = "file" )),
    fileInput(NS(id,"file1"), "Choose a CSV File:", accept = ".csv"),
    
    # Action button Visualize
    actionButton(NS(id,"OK.button"), "OK"),
    
    tableOutput(NS(id,"contents"))
  )
}

visDatasetServer <- function(id, df.survey) {
  moduleServer(id, function(input, output, session) {
    
    
    df.dataset <- reactive({df.survey$data})
    df.current <- reactive({df.survey$current})
    
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
      validate(need(ext == "csv", "Please upload a csv file"))
      df <- read.csv(file$datapath)
      df$relationship <- factor(df$relationship, levels = c("friend","stranger","foe") )
      df$vignette <- factor(df$vignette)
      return (df)
    }, ignoreNULL = FALSE)
 
    
    user_choice <- observeEvent(input$OK.button,{
      if(input$dataset_radio=="file"){
        df.survey$data <- select_file()
      }else{
        df.survey$data <- df.survey$current
      }
      ## use ignoreNULL to fire the event at startup
    }, ignoreNULL = FALSE)
    
    
})
}
