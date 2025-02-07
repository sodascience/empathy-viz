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
                 checkboxInput(ns("akkoord"), "Akkoord")
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
        shinyjs::enable(selector = "#main\\.navbar li a")
      } else {
        showModal(modalDialog(
          title = "Toestemming Vereist",
          "U moet akkoord gaan met de voorwaarden om door te gaan",
          easyClose = TRUE,
          footer = NULL
        ))
        shinyjs::disable(selector = "#main\\.navbar li a")
      }
    })
    
    observe({
      if (!input$akkoord) {
        shinyjs::disable(selector = "#main\\.navbar li a")
      }
    })
  })
}
