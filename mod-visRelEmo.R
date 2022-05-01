library(ggplot2)
library(hash)
source("visualization.R")

visRelEmoUI <- function(id) {
  fluidPage(
    titlePanel("Dynamiek in Relaties * emotie "),  
    sidebarLayout(
      sidebarPanel(
        h6(textOutput(NS(id,"guideline"))),
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

visRelEmoServer <- function(id,guideline_fp,df.vis) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.vis$data})
    vign.cond = hash()
    vign.cond[['pijn']] <- c('1','4')
    vign.cond[['blijdschap']] <- c('2','5')
    vign.cond[['verdriet']] <- c('3','6')
    
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"respons"),"Respons",choices = as.character(unique(df.dataset()$respons)), selected =c("empathie"))
      )
      
    })
    
    # Show the guideline
    output$guideline <- renderText({
      get_guideline_vis(guideline_fp,3)
    })
    
    cr <- reactive({
      a <- df.dataset()[as.character(df.dataset()$respons)%in%input$respons,]
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$relatie, a$vign_cat, a$respons), mean)
      colnames(a_agg) = c("relatie","vign_cat","respons","intensity_mean")
      
      print(a_agg)
      a_agg$vign_cat <- factor(a_agg$vign_cat, levels = c("blijdschap","verdriet","pijn") )
      a_agg
    })
    
    output$chart <- renderPlot({
      validate(
        need(nrow(cr())!=0, "Geen gegevens om te plotten")
      )
       print(plt_em.relatie())     
    })
    
    plt_em.relatie <- reactive({
      p <- ggplot(cr(), aes(x=relatie, y=intensity_mean, colour=respons)) + 
        geom_line(aes(group=interaction(respons)),size=1, alpha=0.5)+
        scale_y_continuous(limits = c(1, 5), 
                           oob = scales::squish)+
        ggtitle("Gemiddelde scores over de twee vignetten")+
        ylab("Intensiteit-gemiddelde") +
        scale_x_discrete(guide = guide_axis(angle = 45))+
        
        My_Theme+
        scale_color_manual(values = respons.colorCode)
      
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
