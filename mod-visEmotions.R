library(ggplot2)
source("visualization.R")

visEmotionUI <- function(id) {
  fluidPage(
    titlePanel("Dynamics Emotion"),  
    sidebarLayout(
      sidebarPanel(
        uiOutput(NS(id,"moreControls"))
      ),
      mainPanel(
        plotOutput(NS(id,"chart_emotion")),
        
      )
    )
  )
}

visEmotionServer <- function(id, df.survey) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.survey$data})
    
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"emotion"),"Emotion",choices = as.character(unique(df.dataset()$emotion)))
      )
    })
    
    cr_emotion <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion,]
      
      validate(
        need(nrow(a)!=0, "No Data to plot")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$emotion, a$vign_cat), mean)
      colnames(a_agg) = c("emotion","vign_cat","intensity_mean")
      print(a_agg)
      a_agg
    })
    
    
    output$chart_emotion <- renderPlot({
      print(nrow(cr_emotion()))
      validate(
        need(nrow(cr_emotion())!=0, "No Data to plot")
      )
      ggplot(cr_emotion(), aes(x=vign_cat, y=intensity_mean, fill=emotion)) +
        geom_col(position = "dodge") +
        ggtitle("DYNAMICS EMOTION") +
        scale_fill_brewer(palette = "Paired")+
        ylab("Intensity-mean") + My_Theme 
        
    })
    
  })
}
