library(ggplot2)
source("visualization.R")

visEmotionUI <- function(id) {
  fluidPage(
    titlePanel(h6( "Dynamiek in Emoties")),  
    sidebarLayout(
      sidebarPanel(
        h6(textOutput(NS(id,"guideline"))),
        uiOutput(NS(id,"moreControls")),
        
        # Action button Download pdf
        downloadButton(NS(id,"Download.pdf"), "Download Grafiek")
      ),
      mainPanel(
        plotOutput(NS(id,"chart_emotion")),
        
      )
    )
  )
}

visEmotionServer <- function(id, guideline_fp, df.vis) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.vis$data})
    
    # Show the guideline
    output$guideline <- renderText({
      get_guideline_vis(guideline_fp,2)
    })
    
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"respons"),"Respons",
                           choices = as.character(unique(df.dataset()$respons)),
                           selected =c("empathie"))
      )
    })
    
    cr_emotion <- reactive({
      a <- df.dataset()[as.character(df.dataset()$respons)%in%input$respons,]
      
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$respons, a$vign_cat), mean)
      colnames(a_agg) = c("respons","vign_cat","intensity_mean")
      # print(a_agg)
      a_agg$vign_cat <- factor(a_agg$vign_cat, levels = c("blijdschap","verdriet","pijn") )
      a_agg
    })
    
    
    output$chart_emotion <- renderPlot({
      
      validate(
        need(nrow(cr_emotion())!=0, "Geen gegevens om te plotten")
      )
      print(plt_emotion())
    })
    
    plt_emotion <- reactive({
      ggplot(cr_emotion(), aes(x=vign_cat, y=intensity_mean)) +
        geom_point(aes(group = respons, color = respons), size = 3, position=position_dodge(width = 0.9))+
        geom_errorbar(aes(group = respons, ymin = 0, ymax = intensity_mean, color = respons), 
                      width = 0, position=position_dodge(width = 0.9), size = 1.5, stat="identity", alpha=0.5)+
        scale_y_continuous(limits = c(1, 5),
                           oob = scales::squish)+
        
        ylab("Intensiteit-gemiddelde") +
        ggtitle("Gemiddelde scores per emotie")+
        My_Theme +
        scale_color_manual(values = respons.colorCode)
    })
    
    output$Download.pdf <- downloadHandler(
      filename = function() {
        paste0("emoties", ".png")
      },
      content = function(file) {
        ggsave(file, plot = plt_emotion(),  bg = "white")
      }
    )
  })
}
