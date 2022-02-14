source("questions.R")
library(shinyRadioMatrix)
library(shinyjs)

questionUI <- function(id) {
  tagList(
  uiOutput(NS(id,"MainAction")),
  
  # Action button Previous
  actionButton(NS(id,"Click.CounterBack"), "<"),
  
  # Action button Download
  downloadButton(NS(id,"Click.Download"), "Download Results"),
  
  # Action button Next
  actionButton(NS(id,"Click.Counter"), "Next"),
  #textOutput(NS(id,"surveyresults"))
  
  )
}

questionServer <- function(id, intro_fp, vignette_fp, relationship_fp, 
                           rmf_fp, counter, input.data) {
  moduleServer(id, function(input, output, session) {
    
    # Read list of described situations
    vignettes <- get_vignettes(vignette_fp)
    # Read list of described sub-situations
    relationships <- get_relationships(relationship_fp)
    # Read radio-buttons rows and columns
    radio.matrix.frame <- get_radioMatrixFrame(rmf_fp)
  
    # Read user's general data
    user.gender <- reactive({input.data$gender})
    user.age <- reactive({input.data$age})
    user.code <- reactive({input.data$code})
    
    df.survey_result <- make.df.survey_result(nrow(vignettes)-1,
                                             nrow(relationships)+1,
                                             nrow(radio.matrix.frame))
    
    # Add to counter() by 1, if Next is clicked
    observeEvent(input$Click.Counter, {
      save.survey.results()
      new.count <- ifelse(counter()<nrow(vignettes),counter() + 1, counter())   
      counter(new.count)
      
      
    })
    
    # Subtract counter() by 1, if Previous is clicked
    observeEvent(input$Click.CounterBack, {
      save.survey.results()
      new.count <- ifelse(counter()>0,counter() - 1,counter())     
      counter(new.count)
    })
    
    # # Download the results of survey locally
    # observeEvent(input$Click.Download, {
    #   download.survey.results()
    #   h4("Successfully downloaded!")
    # })
    # 
    # Hold the primary actions of the survey area
    output$MainAction <- renderUI({
      dynamicUi()
    })
    
    
    # Dynamic UI interface changes as the survey progresses
    dynamicUi <- reactive({
      ns <- session$ns
      
      # show/hide previous button
      if((counter() == 0)||(counter()==nrow(vignettes))){
        shinyjs::hide(id = "Click.CounterBack")
      }else{
        shinyjs::show(id = "Click.CounterBack")
      }

      # show/hide next button
      if (counter()==nrow(vignettes)){
        shinyjs::hide(id = "Click.Counter")
      }else{
        shinyjs::show(id = "Click.Counter")
      }
      
      # show/hide download button
      if (counter()==nrow(vignettes)){
        shinyjs::show(id = "Click.Download")
      }else{
        shinyjs::hide(id = "Click.Download")
      }
      
      # Initially show an introduction to survey
      if (counter()==0)
        return(
          list(
            verticalLayout(
                get_introduction(intro_fp)
            )
          )
        )
      # End Introduction
      # Update survey questions by clicking on Next-button
      if (counter()>0 & counter()<nrow(vignettes))
        return(
          list(
            strong(textOutput(ns("vignette.desc"))),
            radioMatrixInput(inputId = ns("rmi01"), 
                             rowIDs = radio.matrix.frame$qID,
                             rowLLabels = radio.matrix.frame[,counter()+1],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(relationship_items[1])
            ),
  
            strong(textOutput(ns("relationship1"))),
            radioMatrixInput(inputId = ns("rmi02"), 
                             rowIDs = radio.matrix.frame$qID+5,
                             rowLLabels = radio.matrix.frame[,counter()+1],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(relationship_items[2])
            ),
            strong(textOutput(ns("relationship2"))),
            radioMatrixInput(inputId = ns("rmi03"), 
                             rowIDs = radio.matrix.frame$qID+10,
                             rowLLabels = radio.matrix.frame[,counter()+1],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(relationship_items[3])
            )
            
  
          )
        )

      
      # Finally we see results of the survey as well as a
      # download button.
      if (counter()==nrow(vignettes))
        return(
          list(
            h4("Thank you for completing our survey!"),
            h4("View aggregated results:"),
            tableOutput(ns("surveyresults"))
            
          )
        )
      
     })
    
    # Show the situation number (V:) followed by the situation description
    output$vignette.desc <- renderText({
      paste0(
        "V", counter(),":", #counter$countervalue
        vignettes[vignettes$Vnum==counter(),c("Vignette_desc")]
      )
    })
    
    # Show the sub-situation1 description
    output$relationship1 <- renderText({
        relationships[1,c("Relationship_desc")]
    })
    
    # Show the sub-situation2 description
    output$relationship2 <- renderText({
      relationships[2,c("Relationship_desc")]
    })
    
    # Save the results of the survey in memory.
    save.survey.results <- function(){

      
      # After each click, save the results of the radio buttons in df.
      if ((counter()>0)&(counter()<nrow(vignettes))){
        cond1 <- df.survey_result$vignette == counter() &
          df.survey_result$relationship == relationship_items[1]
      
        rmi01 <- nullToNA(input$rmi01)
        try(df.survey_result[cond1,emotion_items] <<-rmi01)
        
        
        cond2 <- df.survey_result$vignette == counter() &
          df.survey_result$relationship == relationship_items[2]
        
        rmi02 <- nullToNA(input$rmi02)
        try(df.survey_result[cond2,emotion_items] <<-rmi02)
        
        
        cond3 <- df.survey_result$vignette == counter() &
          df.survey_result$relationship == relationship_items[3]
        
        rmi03 <- nullToNA(input$rmi03)
        try(df.survey_result[cond3,emotion_items] <<- rmi03)
        
      }

    }
    
    # # Download the results of the survey.
    # download.survey.results <- function(){
    #   # If the user click on download button
    #   # then R saves the results in 'survey.results.Rdata' in working directory
    #   
    #   # working.dir <- getwd()
    #   # file.path <- paste(working.dir ,"/survey.results.Rdata")
    #   
    #   long.survey_result <- refactor_df(df.survey_result)
    #   write.csv2(long.survey_result, "survery_results.csv", row.names = FALSE )
    #   save(df.survey_result, file="survey.results.Rdata")
    #   
    # }
    

    output$Click.Download <- downloadHandler(
      filename = function() {
        paste("data-", user.gender(),"-",user.age(),"-",user.code(), ".csv", sep="")
      },
      content = function(file) {
        long.survey_result <- refactor_df(df.survey_result)
        write.csv(long.survey_result, file)
        h4("Successfully downloaded!")
      }
    )
    
    upload.results <- function(sub.sit){
      
      # After each click, load the existing answers in to the radio buttons.
      if ((counter()>0)&(counter()<nrow(vignettes))){
        cond1 <- df.survey_result$vignette == counter() &
          df.survey_result$relationship == sub.sit
        return (df.survey_result[cond1,emotion_items])
      }
      else
        return (c(0,0,0,0,0))
    }
    # Render the table of results from the survey
    output$surveyresults <- renderTable({
      df.survey_result
    })
    
  })
}

