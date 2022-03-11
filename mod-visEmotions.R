library(ggplot2)
source("visualization.R")

visEmotionUI <- function(id) {
  fluidPage(
    titlePanel("Dynamiek in Emoties"),  
    sidebarLayout(
      sidebarPanel(
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

visEmotionServer <- function(id, df.vis) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.vis$data})
    
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"emotion"),"Emotie",
                           choices = as.character(unique(df.dataset()$emotie)),
                           selected = as.character(unique(df.dataset()$emotie)))
      )
    })
    
    cr_emotion <- reactive({
      a <- df.dataset()[as.character(df.dataset()$emotie)%in%input$emotion,]
      
      validate(
        need(nrow(a)!=0, "Geen gegevens om te plotten")
      )
      a_agg <- aggregate(list(a$value.num), by = list(a$emotie, a$vign_cat), mean)
      colnames(a_agg) = c("emotie","vign_cat","intensity_mean")
      # print(a_agg)
      a_agg
    })
    
    
    output$chart_emotion <- renderPlot({
      
      validate(
        need(nrow(cr_emotion())!=0, "Geen gegevens om te plotten")
      )
      print(plt_emotion())
    })
    
    plt_emotion <- reactive({
      ggplot(cr_emotion(), aes(x=vign_cat, y=intensity_mean, fill=emotie)) +
        geom_bar(position="dodge", stat="identity")+
        scale_y_continuous(limits = c(1, 5),
                           oob = scales::squish)+
        
        ylab("Intensiteit-gemiddelde") +
        My_Theme +
        scale_fill_manual(values = emotion.colorCode)
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
