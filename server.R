library(shiny)
# Read the survey questions
Qlist <- read.csv("Qlist.csv")


shinyServer(function(input, output) {
  
  # Create an empty vector to hold survey results
  results <<- rep("", nrow(Qlist))
  # Name each element of the vector based on the
  # second column of the Qlist
  names(results)  <<- Qlist[,2]
  
  # Hit counter
  output$counter <- 
    renderText({
      if (!file.exists("counter.Rdata")) counter <- 0
      if (file.exists("counter.Rdata")) load(file="counter.Rdata")
      counter <- counter <<- counter + 1
      
      save(counter, file="counter.Rdata")     
      paste0("Hits: ", counter)
    })
  
  # This renderUI function holds the primary actions of the
  # survey area.
  output$MainAction <- renderUI( {
    dynamicUi()
  })
  
  # Dynamic UI is the interface which changes as the survey
  # progresses.  
  dynamicUi <- reactive({
    
    # Initially it shows a welcome message. 
    if (input$Click.Counter==0) 
      return(
        list(
          verticalLayout(
            strong("Survay"),
            p(style="text-align: justify;",
              "We maken het allemaal wel eens mee dat we zien dat iemand zich pijn doet,
                         verdrietig is of juist heel blij is. Als we zien dat iemand zich bijvoorbeeld snijdt,
                         het hoofd stoot of struikelt op straat dan weten we dat dat pijn doet maar voelen dat
                         soms ook. Als we horen dat iemand gepest is of buitengesloten wordt dan vinden we dat
                         vaak zielig en soms worden we van iemand die heel blij is zelf ook een beetje blij.
                         Het meeleven of meevoelen met de emoties van anderen doen we soms ongemerkt en met
                         de ene persoon meer dan met de ander. Wat wij graag van jou willen weten is wat jij
                         voelt en doet wanneer je ziet dat iemand verdrietig is, pijn heeft of juist blij is.",
              style = "font-family: 'times'; font-si18pt"),
            p(style="text-align: justify;",
              "de volgende bladzijde staan een aantal uitspraken die gaan over het meevoelen met
                        anderen in verschillende situaties. Het kan natuurlijk zijn dat je nog nooit zo'n
                        situatie hebt meegemaakt. Probeer je dan voor te stellen hoe dat zou zijn,
                        wat je zou voelen en willen doen.",
              style = "font-family: 'times'; font-si18pt"
            ),
            p(style="text-align: justify;",
              "Er zijn geen goede of foute antwoorden. Het gaat om jouw eigen gevoel.",
              style = "font-family: 'times'; font-si18pt"
              
            ),
            p(style="text-align: justify;",
              "Je antwoord geef je door het cijfer te omcirkelen wat het meest op jou van toepassing is:",
              style = "font-family: 'times'; font-si18pt"
              
            ),
            p(style="text-align: justify;",
              "1= helemaal niet van toepassing",
              style = "font-family: 'times'; font-si18pt"
              
            ),
            p(style="text-align: justify;",
              "2= een beetje van toepassing",
              style = "font-family: 'times'; font-si18pt"
              
            ),
            p(style="text-align: justify;",
              "3= redelijk goed van toepassing",
              style = "font-family: 'times'; font-si18pt"
              
            ),
            p(style="text-align: justify;",
              "4= sterk van toepassing",
              style = "font-family: 'times'; font-si18pt"
              
            ),
            p(style="text-align: justify;",
              "5= heel sterk van toepassing",
              style = "font-family: 'times'; font-si18pt"
              
            )
          )
        )
      )
  
    # Once the next button has been clicked once we see each question
    # of the survey.
    if (input$Click.Counter>0 & input$Click.Counter<=nrow(Qlist))  
      return(
        list(
          h5(textOutput("question")),
          radioButtons("survey", "Please Select:", 
                       c("Prefer not to answer", option.list()))
        )
      )
    
    # Finally we see results of the survey as well as a
    # download button.
    if (input$Click.Counter>nrow(Qlist))
      return(
        list(
          h4("View aggregate results"),
          tableOutput("surveyresults"),
          h4("Thanks for taking the survey!"),
          downloadButton('downloadData', 'Download Individual Results'),
          br(),
          h6("Haven't figured out how to get rid of 'next' button yet")
        )
      )    
  })
  
  # This reactive function is concerned primarily with
  # saving the results of the survey for this individual.
  output$save.results <- renderText({
    # After each click, save the results of the radio buttons.
    if ((input$Click.Counter>0)&(input$Click.Counter>!nrow(Qlist)))
      try(results[input$Click.Counter] <<- input$survey)
    # try is used because there is a brief moment in which
    # the if condition is true but input$survey = NULL
    
    # If the user has clicked through all of the survey questions
    # then R saves the results to the survey file.
    if (input$Click.Counter==nrow(Qlist)+1) {
      if (file.exists("survey.results.Rdata")) 
        load(file="survey.results.Rdata")
      if (!file.exists("survey.results.Rdata")) 
        presults<-NULL
      presults <- presults <<- rbind(presults, results)
      rownames(presults) <- rownames(presults) <<- 
        paste("User", 1:nrow(presults))
      save(presults, file="survey.results.Rdata")
    }
    # Because there has to be a UI object to call this
    # function I set up render text that distplays the content
    # of this funciton.
    ""
  })
  
  # This function renders the table of results from the
  # survey.
  output$surveyresults <- renderTable({
    t(summary(presults))
  })
  
  # This renders the data downloader
  output$downloadData <- downloadHandler(
    filename = "IndividualData.csv",
    content = function(file) {
      write.csv(presults, file)
    }
  )
  
  # The option list is a reative list of elements that
  # updates itself when the click counter is advanced.
  option.list <- reactive({
    qlist <- Qlist[input$Click.Counter,3:ncol(Qlist)]
    # Remove items from the qlist if the option is empty.
    # Also, convert the option list to matrix. 
    as.matrix(qlist[qlist!=""])
  })
  
  # This function show the question number (Q:)
  # Followed by the question text.
  output$question <- renderText({
    paste0(
      "V", input$Click.Counter,":", 
      Qlist[input$Click.Counter,2]
    )
  })
  
})
