source("questions.R")
inputUI <- function(id) {
  tagList(
    h4("Achtergrond Informatie"),
    selectInput(NS(id,"Gender"), "Gender:",
                c("kies je geslacht:" = "select",
                  "Man" = "male",
                  "Vrouw" = "female",
                  "Anders" = "other")),
    textInput(NS(id,"Age"), placeholder = "Leeftijd", label = "Leeftijd:", width = "30%"),
    textInput(NS(id,"Code"), placeholder = "Code", label = "Code:", width = "30%"),
    actionButton(NS(id,"OK.Input"), "OK"),
    h5(textOutput(NS(id,"Message"), container = span))
  )
}

inputServer <- function(id, input.data, parrent.session, tabset.id, tab.target) {
  moduleServer(id, function(input, output, session) {
    
    
    check.valid.input <- function(){
      if(nchar(input$Age)>3)
      {
        updateTextInput(session,'Age',value=substr(input$Age,1,3))
        showModal(modalDialog(
          title = "Fout!",
          "Leeftijdsgrens overschreden!"
        ))
        return(FALSE)
      }
      if(is.na(as.numeric(input$Age)))
      {
        showModal(modalDialog(
          title = "Fout!",
          "Leeftijd moet een cijfer zijn!"
        ))
        return(FALSE)
      }
      if((is.na(as.numeric(input$Age))== FALSE) && ((as.numeric(input$Age)<1) ||(as.numeric(input$Age)>150)))
      {
        showModal(modalDialog(
          title = "Fout!",
          "Geen geldige leeftijd!"
        ))
        return(FALSE)
      }
      return(TRUE)
    }
    
    end_message <- eventReactive(input$OK.Input,{
      if(check.valid.input()){
        input.data$gender <- input$Gender
        input.data$age <- input$Age
        input.data$code <- input$Code
        # paste0("Bedankt voor de informatie. ",
               # "Klik op 'Vragenlijst' om de enquête te starten!")
      }
    })
    
    user_input <- observeEvent(input$OK.Input,{ #
      req(end_message())
      updateTabsetPanel(parrent.session, tabset.id,
                        selected = tab.target)
      
      ## use ignoreNULL to fire the event at startup
    }, ignoreNULL = FALSE) 
    # output$Message <- renderText({
    #   end_message()
    #   })

    })
}


