source("questions.R")
library(shinyRadioMatrix)
library(shinyjs)

questionUI <- function(id) {
  tagList(
  uiOutput(NS(id,"MainAction")),
  
  # Action button Previous
  actionButton(NS(id,"Click.CounterBack"), "<"),
  
  # Action button Download
  actionButton(NS(id,"Click.Download"), "Download Results"),
  
  # Action button Next
  actionButton(NS(id,"Click.Counter"), "Next"),
  #textOutput(NS(id,"surveyresults"))
  
  )
}

questionServer <- function(id, intro_fp, situations_fp, sub_situations_fp, 
                           rmf_fp, counter) {
  moduleServer(id, function(input, output, session) {
    
    # Read list of described situations
    situations <- get_situations(situations_fp)
    # Read list of described sub-situations
    sub_situations <- get_sub_situations(sub_situations_fp)
    # Read radio-buttons rows and columns
    radio.matrix.frame <- get_radioMatrixFrame(rmf_fp)
    
    # Create a dataframe to hold survey results
    df.survey_result<- make.df.survey_result(nrow(situations)-1,
                                             nrow(sub_situations)+1,
                                             nrow(radio.matrix.frame))
    
    
    # Add to counter() by 1, if Next is clicked
    observeEvent(input$Click.Counter, {
      save.survey.results()
      new.count <- ifelse(counter()<nrow(situations),counter() + 1, counter())   
      counter(new.count)
      
    })
    
    # Subtract counter() by 1, if Previous is clicked
    observeEvent(input$Click.CounterBack, {
      save.survey.results()
      new.count <- ifelse(counter()>0,counter() - 1,counter())     
      counter(new.count)
    })
    
    # Download the results of survey locally
    observeEvent(input$Click.Download, {
      download.survey.results()
      h4("Successfully downloaded!")
    })
    
    # Hold the primary actions of the survey area
    output$MainAction <- renderUI({
      dynamicUi()
    })
    
    
    # Dynamic UI interface changes as the survey progresses
    dynamicUi <- reactive({
      ns <- session$ns
      
      # show/hide previous button
      if((counter() == 0)||(counter()==nrow(situations))){
        shinyjs::hide(id = "Click.CounterBack")
      }else{
        shinyjs::show(id = "Click.CounterBack")
      }

      # show/hide next button
      if (counter()==nrow(situations)){
        shinyjs::hide(id = "Click.Counter")
      }else{
        shinyjs::show(id = "Click.Counter")
      }
      
      # show/hide download button
      if (counter()==nrow(situations)){
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
      if (counter()>0 & counter()<nrow(situations))
        return(
          list(
            strong(textOutput(ns("situation.desc"))),
            radioMatrixInput(inputId = ns("rmi01"), 
                             rowIDs = radio.matrix.frame$qID,
                             rowLLabels = radio.matrix.frame[,counter()+1],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(1)
            ),
  
            strong(textOutput(ns("sub_situation1"))),
            radioMatrixInput(inputId = ns("rmi02"), 
                             rowIDs = radio.matrix.frame$qID+5,
                             rowLLabels = radio.matrix.frame[,counter()+1],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(2)
            ),
            strong(textOutput(ns("sub_situation2"))),
            radioMatrixInput(inputId = ns("rmi03"), 
                             rowIDs = radio.matrix.frame$qID+10,
                             rowLLabels = radio.matrix.frame[,counter()+1],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(3)
            )
            
  
          )
        )

      
      # Finally we see results of the survey as well as a
      # download button.
      if (counter()==nrow(situations))
        return(
          list(
            h4("View aggregate results"),
            tableOutput(ns("surveyresults")),
            h4("Thanks for taking the survey!")
            
          )
        )
      
     })
    
    # Show the situation number (V:) followed by the situation description
    output$situation.desc <- renderText({
      paste0(
        "V", counter(),":", #counter$countervalue
        situations[situations$Snum==counter(),c("Situation")]
      )
    })
    
    # Show the sub-situation1 description
    output$sub_situation1 <- renderText({
        sub_situations[1,c("Sub_Situation")]
    })
    
    # Show the sub-situation2 description
    output$sub_situation2 <- renderText({
      sub_situations[2,c("Sub_Situation")]
    })
    
    # Save the results of the survey in memory.
    save.survey.results <- function(){

      # After each click, save the results of the radio buttons in df.
      if ((counter()>0)&(counter()<nrow(situations))){
        cond1 <- df.survey_result$situation == counter() &
          df.survey_result$sub.situation == 1
      
        rmi01 <- nullToNA(input$rmi01)
        try(df.survey_result[cond1,c('q1','q2','q3','q4','q5')] <<-rmi01)
        
        
        cond2 <- df.survey_result$situation == counter() &
          df.survey_result$sub.situation == 2
        
        rmi02 <- nullToNA(input$rmi02)
        try(df.survey_result[cond2,c('q1','q2','q3','q4','q5')] <<-rmi02) 

        cond3 <- df.survey_result$situation == counter() &
          df.survey_result$sub.situation == 3
        
        rmi03 <- nullToNA(input$rmi03)
        try(df.survey_result[cond3,c('q1','q2','q3','q4','q5')] <<- rmi03)
      }

    }
    
    # Download the results of the survey.
    download.survey.results <- function(){
      # If the user click on download button
      # then R saves the results in 'survey.results.Rdata' in working directory
      
      # working.dir <- getwd()
      # file.path <- paste(working.dir ,"/survey.results.Rdata")
      save(df.survey_result, file="survey.results.Rdata")
      
    }
    
    upload.results <- function(sub.sit){
      
      # After each click, load the existing answers in to the radio buttons.
      if ((counter()>0)&(counter()<nrow(situations))){
        cond1 <- df.survey_result$situation == counter() &
          df.survey_result$sub.situation == sub.sit
        return (df.survey_result[cond1,c('q1','q2','q3','q4','q5')])
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

