source("questions.R")
inputUI <- function(id) {
  tagList(
    h4("Background information"),
    selectInput(NS(id,"Gender"), "Gender:",
                c("select your gender:" = "select",
                  "Male" = "male",
                  "Female" = "female",
                  "Other" = "other")),
    textInput(NS(id,"Age"), placeholder = "Age", label = "Age:", width = "30%"),
    textInput(NS(id,"Code"), placeholder = "Code", label = "Code:", width = "30%"),
    actionButton(NS(id,"OK.Input"), "OK"),
    h5(textOutput(NS(id,"Message"), container = span))
  )
}

inputServer <- function(id, input.data) {
  moduleServer(id, function(input, output, session) {
    
    end_message <- eventReactive(input$OK.Input,{
      input.data$gender <- input$Gender
      input.data$age <- input$Age
      input.data$code <- input$Code
      print(input.data$gender)
      paste0("Thanks for the information.",
             "Please click on 'Questionnaire' to start the survey!")
    })
    output$Message <- renderText({
      end_message()
      })
    })
}

