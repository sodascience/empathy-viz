source("questions.R")
library(shiny)


disclaimerUI <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "disclaimer-content",
        fluidRow(
          column(2, 
                 imageOutput(ns("logo_left"), height = "auto"),
                 style = "margin-bottom: 0px; padding-bottom: 0px; text-align: left;"
          ),
          column(10, 
                 imageOutput(ns("logo_right"), height = "auto"),
                 style = "margin-bottom: 0px; padding-bottom: 0px; text-align: right;"
          )
        ),
        fluidRow(
          column(12, 
                 uiOutput(ns("title")), 
                 style = "margin-top: 0px; padding-top: 0px;"
          )
        ),
        fluidRow(
          column(12, 
                 uiOutput(ns("participant_names")), 
                 style = "margin-top: 0px; padding-top: 0px;"
          )
        ),
        fluidRow(
          column(12, 
                 imageOutput(ns("github_logo"), height = "auto"),
                 style = "margin-bottom: 0px; padding-bottom: 0px;"
          )
        ),
        fluidRow(
          column(12, 
                 uiOutput(ns("additional_text")), 
                 style = "margin-top: 0px; padding-top: 0px;"
          )
        ),
        fluidRow(
          column(12, 
                 checkboxInput(ns("akkoord"), "Ik ga akkoord met de algemene voorwaarden.")
          )
        ),
        fluidRow(
          column(12, 
                 actionButton(ns("ok"), "OK")
          )
        )
    )
  )
}

disclaimerServer <- function(id, parent.session, tabset.id, tab.target, disclaimer_file_path) {
  moduleServer(id, function(input, output, session) {
    config <- get_disclaimer(disclaimer_file_path)
    
    output$logo_left <- renderImage({
      list(src = config$logo_left_path,
           contentType = 'image/png',
           width = "100px",
           height = "100px")
    }, deleteFile = FALSE)
    
    output$logo_right <- renderImage({
      list(src = config$logo_right_path,
           contentType = 'image/png',
           width = "250px",
           height = "100px")
    }, deleteFile = FALSE)
    
    output$title <- renderUI({
      tags$h3(style = "color: red;", config$title)
    })
    
    output$participant_names <- renderUI({
      tags$p(HTML(config$participant_names))
    })
    
    output$github_logo <- renderImage({
      list(src = config$github_logo_path,
           contentType = 'image/png',
           width = "50px",
           height = "50px")
    }, deleteFile = FALSE)
    
    output$additional_text <- renderUI({
      tags$p(config$additional_text)
    })
    
    observeEvent(input$ok, {
      if (input$akkoord) {
        updateTabsetPanel(parent.session, tabset.id, selected = tab.target)
      } else {
        showModal(modalDialog(
          title = "Toestemming Vereist",
          "U moet akkoord gaan met de voorwaarden om door te gaan",
          easyClose = TRUE,
          footer = NULL
        ))
      }
    })
  })
}
