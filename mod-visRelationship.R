library(ggplot2)
library(hash)
source("visualization.R")

visRelationshipUI <- function(id) {
  fluidPage(
    titlePanel("Dynamiek in Relaties "),  
    sidebarLayout(
      sidebarPanel(
        uiOutput(NS(id,"moreControls")),
        # Action button Download pdf
        downloadButton(NS(id,"Download.pdf"), "Download Grafiek")
      ),
      
      mainPanel(
        plotOutput(NS(id,"chart"))
        
      )
    )
  )
}

visRelationshipServer <- function(id, df.vis, vign.type) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.vis$data})
    vign.cond = hash()
    vign.cond[['pijn']] <- c('1','4')
    vign.cond[['blijdschap']] <- c('2','5')
    vign.cond[['verdriet']] <- c('3','6')
    
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"vignette"),"Vignet",choices = as.character(vign.cond[[vign.type]])),
        checkboxGroupInput(NS(id,"emotion"),"Emotie",choices = as.character(unique(df.dataset()$emotie)))
      )
      
    })
    
    
    cr <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotie)%in%input$emotion
                            & as.character(df.dataset()$vignet)%in%input$vignette & 
                              as.character(df.dataset()$vignet)%in% vign.cond[[vign.type]],]
      print(a)
      a
    })
    
    output$chart <- renderPlot({
      validate(
        need(nrow(cr())!=0, "Geen gegevens om te plotten")
      )
      print(plt_relatie())
      
    })
    
    plt_relatie <- reactive({
      ggplot(cr(), aes(x=relatie, y=value.num, linetype=vignet, colour=emotie)) + 
        geom_line(aes(group=interaction(vignet, emotie)), size=1, alpha=0.5)+
        #geom_point(aes(shape=emotion)) +
        ggtitle(paste0("Dynamiek in relaties: ",vign.type)) +
        ylim(1,5)+ylab("Intensiteit") +
        My_Theme+
        scale_color_manual(values = emotion.colorCode)
    })
    output$Download.pdf <- downloadHandler(
      filename = function() {
        paste0("relatie_",vign.type,".png")
      },
      content = function(file) {
        ggsave(file, plot = plt_relatie(),  bg = "white")
      }
    )
  })
}
