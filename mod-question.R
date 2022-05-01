source("questions.R")
library(shinyRadioMatrix)
library(shinyjs)
library("writexl")
library("shinyWidgets")
library(gridExtra)

questionUI <- function(id) {
  tagList(
  uiOutput(NS(id,"MainAction")),
  
  # Action button Previous
  actionButton(NS(id,"Click.CounterBack"), "<"),
  
  # Action button Next
  actionButton(NS(id,"Click.Counter"), "Volgende")
 
  
  )
}

questionServer <- function(id, intro_fp, vignette_fp, relationship_fp, 
                           rmf_fp, ending_fp, counter, input.data, df.survey) {
  moduleServer(id, function(input, output, session) {
    
    # Read list of described situations
    vignettes <- get_vignettes(vignette_fp)
    # Read list of described sub-situations
    relationships <- get_relationships(relationship_fp)
    # Read radio-buttons rows and columns
    radio.matrix.frame <- get_radioMatrixFrame(rmf_fp)
    # Read text/image of the ending page
    end.df <- get_ending(ending_fp)
    # Read user's general data
    user.gender <- reactive({input.data$gender})
    user.age <- reactive({input.data$age})
    user.code <- reactive({input.data$code})
    
    #observe({shinyjs::runjs("window.scrollTo(0, 0)")})
    df.survey_result <- reactive({df.survey$data})
    
    # Create a dataframe to hold survey results
    df.survey$data <- make.df.survey_result(nrow(vignettes)-1,
                                             nrow(radio.matrix.frame))
    
    
    # Add to counter() by 1, if Next is clicked
    observeEvent(input$Click.Counter, {
      if (counter()<2 ||check.complete.survey()){
        save.survey.results()
        new.count <- ifelse(counter()<=nrow(vignettes)+1,counter() + 1, counter())   
        counter(new.count)
        
      }
      {shinyjs::runjs("window.scrollTo(0, 0)")}
    })
    
    # Subtract counter() by 1, if Previous is clicked
    observeEvent(input$Click.CounterBack, {
      save.survey.results()
      new.count <- ifelse(counter()>0,counter() - 1,counter())     
      counter(new.count)
      {shinyjs::runjs("window.scrollTo(0, 0)")}
    })
    
    
    # Hold the primary actions of the survey area
    output$MainAction <- renderUI({
      dynamicUi()
    })
    
    
    # Dynamic UI interface changes as the survey progresses
    dynamicUi <- reactive({
      ns <- session$ns
      
      # show/hide previous button
      if((counter() == 0)){ #||(counter()==nrow(vignettes))){
        shinyjs::hide(id = "Click.CounterBack")
      }else{
        shinyjs::show(id = "Click.CounterBack")
      }

      # show/hide next button
      if (counter()==(nrow(vignettes)+2)){
        shinyjs::hide(id = "Click.Counter")
      }else{
        shinyjs::show(id = "Click.Counter")
       
      }
      
      
      # Initially show an introduction to survey
      if (counter()==0)
        return(
          list(
            verticalLayout(
               h5(get_introduction(intro_fp,1))
            )
          )
        )
      
      if (counter()==1)
        return(
          list(
            verticalLayout(
              h5(get_introduction(intro_fp,2))
            )
          )
        )
      # End Introduction
      # Update survey questions by clicking on Next-button
      if (counter()>1 & counter()<(nrow(vignettes)+1))
        return(
          list(
            progressBar(
                id = NS(id,"pb"),
                value = counter()-1,
                total = nrow(vignettes)-1,
                title = "",
                display_pct = TRUE
              ),
            h3(textOutput(ns("vignette.title"))),
            strong(textOutput(ns("vignette.desc"))),
            radioMatrixInput(inputId = ns("rmi01"), 
                             rowIDs = radio.matrix.frame$qID,
                             rowLLabels = radio.matrix.frame[,counter()],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(relationship_items[1])
            ),
            
            strong(textOutput(ns("relationship1"))),
            radioMatrixInput(inputId = ns("rmi02"), 
                             rowIDs = radio.matrix.frame$qID+5,
                             rowLLabels = radio.matrix.frame[,counter()],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(relationship_items[2])
            ),
            strong(textOutput(ns("relationship2"))),
            radioMatrixInput(inputId = ns("rmi03"), 
                             rowIDs = radio.matrix.frame$qID+10,
                             rowLLabels = radio.matrix.frame[,counter()],
                             choices = radio.matrix.frame$columnNames,
                             selected = upload.results(relationship_items[3])
            )
            
            
          )
        )
      
      if (counter()==(nrow(vignettes)+1)){
        
        return(
          list(

            fluidRow(align = "center",
              column(12, align="center",
                     h2(end.df[1,'text'], style = "font-weight: 500; color: black;"),
                     h2(end.df[2,'text'], style = "font-weight: 500; color: black;"),
                     h2(" "),
                     imageOutput(ns("img.hooray"))
              )
            )
            
          )
        )
    }
      if (counter()==(nrow(vignettes)+2))
        return(
          list(
            h4("Enquêteresultaten downloaden:"),
            # Action button Download csv
            downloadButton(ns("Click.Download.csv"), "CSV downloaden"),
            
            # Action button Download excel
            downloadButton(ns("Click.Download.excel"), "Excel downloaden"),
            
            # Action button Download pdf
            downloadButton(ns("Click.Download.pdf"), "PDF downloaden"),
            
            h4("Geaggregeerde resultaten bekijken"),
            tableOutput(ns("surveyresults"))
            
          )
        )
      
     })
    
    # Show the situation title
    output$vignette.title <- renderText({
      paste0(
        vignettes[vignettes$Vnum==(counter()-1),c("Vignette_title")],":"
      )
    })
    
    # Show the situation description
    output$vignette.desc <- renderText({
        vignettes[vignettes$Vnum==(counter()-1),c("Vignette_desc")]
    })
    
    # Show the sub-situation1 description
    output$relationship1 <- renderText({
        relationships[(relationships$Vnum==(counter()-1)) & (relationships$Rnum==1),c("Relationship_desc")]
    })
    
    # Show the sub-situation2 description
    output$relationship2 <- renderText({
      relationships[(relationships$Vnum==(counter()-1)) & (relationships$Rnum==2),c("Relationship_desc")]
    })
    
    # Save the results of the survey in memory.
    save.survey.results <- function(){
      # After each click, save the results of the radio buttons in df.
      if ((counter()>1)&(counter()<=nrow(vignettes))){
        cond1 <- df.survey_result()$vignet == (counter()-1) &
          df.survey_result()$relatie == relationship_items[1]
        
        rmi01 <- nullToNA(input$rmi01)
        try(df.survey$data[cond1,respons_items] <<-rmi01)
        
        
        cond2 <- df.survey_result()$vignet == (counter()-1) &
          df.survey_result()$relatie == relationship_items[2]
        
        rmi02 <- nullToNA(input$rmi02)
        try(df.survey$data[cond2,respons_items] <<-rmi02)
        
        
        cond3 <- df.survey_result()$vignet == (counter()-1) &
          df.survey_result()$relatie == relationship_items[3]
        
        rmi03 <- nullToNA(input$rmi03)
        try(df.survey$data[cond3,respons_items] <<- rmi03)
        
      }
      
    }
    
    # check all questions are answered.
    check.complete.survey<- function(){
      hasNull_1 <- any(sapply(input$rmi01, is.null))
      hasNull_2 <- any(sapply(input$rmi02, is.null))
      hasNull_3 <- any(sapply(input$rmi03, is.null))
      if(hasNull_1 || hasNull_2 || hasNull_3){
        showModal(modalDialog(
          title = "Error!",
          "Gelieve alle vragen te beantwoorden!",
          footer = modalButton("OK"),
        ))

        return (FALSE)
      }
      else
        return (TRUE)
      
    }
   
    output$Click.Download.csv <- downloadHandler(
           filename = function() {
                paste("data", user.gender(),user.age(),user.code(), ".csv", sep="-")
          },
          content = function(file) {
                print(df.survey_result())
                long.survey_result <- refactor_df(df.survey_result())
                write.csv(long.survey_result, file)
          }
      )
    
    output$Click.Download.excel <- downloadHandler(
      filename = function() {
        paste("data", user.gender(),user.age(),user.code(), ".xlsx", sep="-")
      },
      content = function(file) {
        numeric.survey.result <- to_numeric_df(df.survey_result())
        write_xlsx(numeric.survey.result, file)
      }
    )
    
    output$Click.Download.pdf <- downloadHandler(
      filename = function() {
        paste("data", user.gender(),user.age(),user.code(), ".pdf", sep="-")
      },
      content = function(file) {
        numeric.survey.result <- to_numeric_df(df.survey_result())
        pdf(file = file)
        grid.table(numeric.survey.result)
        dev.off()
      }
    )
    upload.results <- function(sub.sit){
      # After each click, load the existing answers in to the radio buttons.
      if ((counter()>1)&(counter()<=nrow(vignettes))){
        
        cond1 <- df.survey_result()$vignet == (counter()-1) &
          df.survey_result()$relatie == sub.sit
        return (df.survey_result()[cond1,respons_items])
      }
      else
        return (c(0,0,0,0,0))
    }
    # Render the table of results from the survey
    output$surveyresults <- renderTable({
      to_numeric_df(df.survey_result())
    })
    
    output$img.hooray <- renderImage({
      list(src = end.df[1,'img'],
           contentType = "image/jpg",
           width = "85",
           height = "73")},
      deleteFile = FALSE) 

  })
}

