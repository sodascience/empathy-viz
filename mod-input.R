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

source("questions.R")
inputUI <- function(id) {
  tagList(
    h4("Achtergrond Informatie"),
    selectInput(NS(id,"Gender"), "Geslacht:",
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
      if((is.na(as.numeric(input$Age))== FALSE) && ((as.numeric(input$Age)<1) ||(as.numeric(input$Age)>70)))
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
