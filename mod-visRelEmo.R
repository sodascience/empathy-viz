library(ggplot2)
library(hash)
source("visualization.R")

visRelEmoUI <- function(id) {
  fluidPage(
    titlePanel("Dynamiek in Relaties * emotie "),  
    sidebarLayout(
      sidebarPanel(
        uiOutput(NS(id,"moreControls")),
        # Action button Download pdf
        downloadButton(NS(id,"Download.pdf"), "Download Grafiek"),
        width = 3
      ),
      
      mainPanel(
        plotOutput(NS(id,"chart"))
        
      )
    )
  )
}

visRelEmoServer <- function(id, df.vis) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.vis$data})
    vign.cond = hash()
    vign.cond[['pijn']] <- c('1','4')
    vign.cond[['blijdschap']] <- c('2','5')
    vign.cond[['verdriet']] <- c('3','6')
    
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"emotion"),"Emotie",choices = as.character(unique(df.dataset()$emotie)))
      )
      
    })
    
    
    cr <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotie)%in%input$emotion,]
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$relatie, a$vign_cat, a$emotie), mean)
      colnames(a_agg) = c("relatie","vign_cat","emotie","intensity_mean")
      
      print(a_agg)
      a_agg
    })
    
    output$chart <- renderPlot({
      validate(
        need(nrow(cr())!=0, "Geen gegevens om te plotten")
      )
       print(plt_em.relatie())     
    })
    
    plt_em.relatie <- reactive({
      p <- ggplot(cr(), aes(x=relatie, y=intensity_mean, colour=emotie)) + 
        geom_line(aes(group=interaction(emotie)),size=1, alpha=0.5)+
        scale_y_continuous(limits = c(1, 5), 
                           oob = scales::squish)+
        ylab("Intensiteit-gemiddelde") +
        scale_x_discrete(guide = guide_axis(angle = 45))+
        
        My_Theme+
        scale_color_manual(values = emotion.colorCode)
      
      p + facet_grid(~vign_cat, scales = "free", space='free')+ 
        theme(strip.text.x = element_text(size = 18))
      
    })
    
    output$Download.pdf <- downloadHandler(
      filename = function() {
        paste0("em_relatie",".png")
      },
      content = function(file) {
        ggsave(file, plot = plt_em.relatie(),  bg = "white")
      }
    )
    
  })
}
