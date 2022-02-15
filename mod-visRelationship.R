library(ggplot2)
source("visualization.R")

visRelationshipUI <- function(id) {
  fluidPage(
    titlePanel("Dynamics Relationship"),  
    sidebarLayout(
      sidebarPanel(
        uiOutput(NS(id,"moreControls"))
      ),
      mainPanel(
        plotOutput(NS(id,"chart_pain")),
        plotOutput(NS(id,"chart_happy")),
        plotOutput(NS(id,"chart_sad"))
      )
    )
  )
}

visRelationshipServer <- function(id, df.survey) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.survey$data})
    
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"vignette"),"Vignette",choices = as.character(unique(df.dataset()$vignette))),
        checkboxGroupInput(NS(id,"emotion"),"Emotion",choices = as.character(unique(df.dataset()$emotion)))
      )
    })
    
    cr_pain <- reactive({
      print(df.dataset())
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion
                            & as.character(df.dataset()$vignette)%in%input$vignette & 
                              as.character(df.dataset()$vignette)%in% c('1','4'),]
      print(a)
      a
    })
    
    cr_happy <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion
                            & as.character(df.dataset()$vignette)%in%input$vignette & 
                              as.character(df.dataset()$vignette)%in% c('2','5'),]
      print(a)
      a
    })
    cr_sad <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion
                            & as.character(df.dataset()$vignette)%in%input$vignette & 
                              as.character(df.dataset()$vignette)%in% c('3','6'),]
      print(a)
      a
    })
    
    
    output$chart_pain <- renderPlot({
      validate(
        need(nrow(cr_pain())!=0, "No Data to plot")
      )
      ggplot(cr_pain(), aes(x=relationship, y=value.num, linetype=vignette, colour=emotion)) + 
        geom_line(aes(group=interaction(vignette, emotion)), size=1, alpha=0.5)+
        #geom_point(aes(shape=emotion)) +
        ggtitle("Emotions in Pain Vignettes ") +
        ylab("Intensity") + My_Theme 
      
    })
    
    
    output$chart_happy <- renderPlot({
      validate(
        need(nrow(cr_happy())!=0, "No Data to plot")
      )
      ggplot(cr_happy(), aes(x=relationship, y=value.num, colour=emotion, linetype=vignette)) + 
        geom_line(aes(group=interaction(vignette, emotion)), size=1, alpha=0.5)+ 
        #geom_point(aes(shape=emotion), size=3, alpha=0.5) +
        ggtitle("Emotions in Happiness Vignettes ") +
        ylab("Intensity") + My_Theme 
      
    })
    
    output$chart_sad <- renderPlot({
      validate(
        need(nrow(cr_sad())!=0, "No Data to plot")
      )
      ggplot(cr_sad(), aes(x=relationship, y=value.num, linetype=vignette, colour=emotion)) + 
        geom_line(aes(group=interaction(vignette, emotion)), size=1, alpha=0.5)+
        #geom_point(aes(shape=emotion)) +
        ggtitle("Emotions in Sadness Vignettes ") +
        ylab("Intensity") + My_Theme 
      
    })
    
  })
}
