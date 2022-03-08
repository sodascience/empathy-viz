library(ggplot2)
source("visualization.R")

visRelEmoUI <- function(id) {
  fluidPage(
    titlePanel("Dynamics Relationship * Emotion"),  
    sidebarLayout(
      sidebarPanel(
        uiOutput(NS(id,"moreControls"))
      ),
      mainPanel(
        plotOutput(NS(id,"chart_empathy")),
        plotOutput(NS(id,"chart_sympathy")),
        plotOutput(NS(id,"chart_distress")),
        plotOutput(NS(id,"chart_helping")),
        plotOutput(NS(id,"chart_counter"))
        
      )
    )
  )
}

visRelEmoServer <- function(id, df.survey) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.survey$data})
    
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"relationship"),"Relationship",choices = as.character(unique(df.dataset()$relationship))),
        checkboxGroupInput(NS(id,"emotion"),"Emotion",choices = as.character(unique(df.dataset()$emotion)))
      )
    })
    
    cr_empathy <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion &
                        as.character(df.dataset()$relationship)%in%input$relationship &
                        as.character(df.dataset()$emotion)=="empathie",] 
      
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$vign_cat, a$relationship), mean)
      colnames(a_agg) = c("vign_cat","relationship","intensity_mean")
      print(a_agg)
      a_agg
    })
    
    cr_sympathy <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion &
                        as.character(df.dataset()$relationship)%in%input$relationship &
                        as.character(df.dataset()$emotion)=="sympathie",] 
      
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$vign_cat, a$relationship), mean)
      colnames(a_agg) = c("vign_cat","relationship","intensity_mean")
      a_agg
    })
    
    cr_distress <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion &
                        as.character(df.dataset()$relationship)%in%input$relationship &
                        as.character(df.dataset()$emotion)=="distress",]
      
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$vign_cat, a$relationship), mean)
      colnames(a_agg) = c("vign_cat","relationship","intensity_mean")
      a_agg
    })
    
    cr_helping <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion &
                        as.character(df.dataset()$relationship)%in%input$relationship &
                        as.character(df.dataset()$emotion)=="gedrag",]
      
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$vign_cat, a$relationship), mean)
      colnames(a_agg) = c("vign_cat","relationship","intensity_mean")
      a_agg
    })
    
    cr_counter <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotion)%in%input$emotion &
                        as.character(df.dataset()$relationship)%in%input$relationship &
                        as.character(df.dataset()$emotion)=="counter-empathie",] 
      
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      print(a)
      a_agg <- aggregate(list(a$value.num), by = list(a$vign_cat, a$relationship), mean)
      colnames(a_agg) = c("vign_cat","relationship","intensity_mean")
      print(a_agg)
      a_agg
    })
    
    
    output$chart_empathy <- renderPlot({
      validate(
        need(nrow(cr_empathy())!=0, "Geen gegevens om te plotten")
      )
      ggplot(cr_empathy(), aes(x=vign_cat, y=intensity_mean, fill=relationship)) +
        geom_col(position = "dodge") +
        ggtitle("Empathie") +
        scale_fill_brewer(palette = "Paired")+
        ylab("gemiddelde van intensiteit") + My_Theme 
    })
    
    
    output$chart_sympathy <- renderPlot({
      validate(
        need(nrow(cr_sympathy())!=0, "Geen gegevens om te plotten")
      )
      ggplot(cr_sympathy(), aes(x=vign_cat, y=intensity_mean, fill=relationship)) +
        geom_col(position = "dodge") +
        ggtitle("Sympathie") +
        scale_fill_brewer(palette = "Paired")+
        ylab("gemiddelde van intensiteit") + My_Theme 
    })
    
    output$chart_distress <- renderPlot({
      validate(
        need(nrow(cr_distress())!=0, "Geen gegevens om te plotten")
      )
      ggplot(cr_distress(), aes(x=vign_cat, y=intensity_mean, fill=relationship)) +
        geom_col(position = "dodge") +
        ggtitle("Distress") +
        scale_fill_brewer(palette = "Paired")+
        ylab("gemiddelde van intensiteit") + My_Theme 
    })
    
    output$chart_helping <- renderPlot({
      validate(
        need(nrow(cr_helping())!=0, "Geen gegevens om te plotten")
      )
      ggplot(cr_helping(), aes(x=vign_cat, y=intensity_mean, fill=relationship)) +
        geom_col(position = "dodge") +
        ggtitle("Gedrag") +
        scale_fill_brewer(palette = "Paired")+
        ylab("gemiddelde van intensiteit") + My_Theme 
    })
    
    
    output$chart_counter <- renderPlot({
      validate(
        need(nrow(cr_counter())!=0, "Geen gegevens om te plotten")
      )
      ggplot(cr_counter(), aes(x=vign_cat, y=intensity_mean, fill=relationship)) +
        geom_col(position = "dodge") +
        ggtitle("Counter-Empathie") +
        scale_fill_brewer(palette = "Paired")+
        ylab("gemiddelde van intensiteit") + My_Theme 
    })
    
    
  })
}
