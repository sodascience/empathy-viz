source("questions.R")
library(shinyRadioMatrix)
questionUI <- function(id) {
  tagList(
  uiOutput(NS(id,"MainAction")),
  # Action button Previous
  actionButton(NS(id,"Click.CounterBack"), "Previous"),
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
    
    observeEvent(input$Click.CounterBack, {
      save.survey.results()
      new.count <- ifelse(counter()>0,counter() - 1,counter())     
      counter(new.count)
      
    })
    
    # Hold the primary actions of the survey area
    output$MainAction <- renderUI({
      dynamicUi()
    })
    
    
    # Dynamic UI interface changes as the survey progresses
    dynamicUi <- reactive({
      ns <- session$ns
      
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
                             choices = radio.matrix.frame$columnNames
            ),
  
            strong(textOutput(ns("sub_situation1"))),
            radioMatrixInput(inputId = ns("rmi02"), 
                             rowIDs = radio.matrix.frame$qID+5,
                             rowLLabels = radio.matrix.frame[,counter()+1],
                             choices = radio.matrix.frame$columnNames
            ),
            strong(textOutput(ns("sub_situation2"))),
            radioMatrixInput(inputId = ns("rmi03"), 
                             rowIDs = radio.matrix.frame$qID+10,
                             rowLLabels = radio.matrix.frame[,counter()+1],
                             choices = radio.matrix.frame$columnNames
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
            # downloadButton('downloadData', 'Download Individual Results'),
            # br(),
            # h6("Haven't figured out how to get rid of 'next' button yet")
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
    
    # saving the results of the survey for this individual.
    save.survey.results <- function(){
      print(counter())
      # After each click, save the results of the radio buttons.
      if ((counter()>0)&(counter()<nrow(situations))){
        cond1 <- df.survey_result$situation == counter() &
          df.survey_result$sub.situation == 1
      
        #try(df.survey_result[cond1,c('q1','q2','q3','q4','q5')] <- c(1,1,1,1,1))
        try(df.survey_result[cond1,c('q1','q2','q3','q4','q5')] <<- input$rmi01)
       
        # Try is used because of a brief moment in which
        # the if condition is true but input$survey = NULL

        cond2 <- df.survey_result$situation == counter() &
          df.survey_result$sub.situation == 2
        try(df.survey_result[cond2,c('q1','q2','q3','q4','q5')] <<-input$rmi02) #c(NULL,NULL,NULL,NULL,NULL)) )

        cond3 <- df.survey_result$situation == counter() &
          df.survey_result$sub.situation == 3
        try(df.survey_result[cond3,c('q1','q2','q3','q4','q5')] <<- input$rmi03)
        print(df.survey_result)
      }


      # If the user has clicked through all of the survey questions
      # then R saves the results to the survey file
      if (counter()==nrow(situations)) {
        
        save(df.survey_result, file="survey.results.Rdata")
      }
      
    }
    
    # Render the table of results from the survey
    output$surveyresults <- renderTable({
      df.survey_result
    })
    
  })
}