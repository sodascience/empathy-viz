library(ggplot2)
library(hash)
source("visualization.R")

visRelationshipUI <- function(id) {
  fluidPage(
    titlePanel("Dynamiek in Relaties "),  
    sidebarLayout(
      sidebarPanel(
        h6(textOutput(NS(id,"guideline"))),
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

visRelationshipServer <- function(id, df.vis, vignette_fp, guideline_fp, vign.type) {
  moduleServer(id, function(input, output, session) {
    df.dataset <- reactive({df.vis$data})
    
    vignettes <- get_vignettes(vignette_fp)
    # add two columns 'Vnum'-'Vignette_title'
    cols <- c("Vnum","Vignette_title")
    vign.no.title <- apply( vignettes[ , cols ] , 1 , paste , collapse = "-" )
    
    vign.cond_name = hash()
    vign.cond_name[['pijn']] <- list(vign.no.title[2],vign.no.title[5]) #vignettes[vignettes$Vnum %in% c('1','4'),"Vignette_title"]
    vign.cond_name[['blijdschap']] <- list(vign.no.title[3],vign.no.title[6]) 
    vign.cond_name[['verdriet']] <- list(vign.no.title[4],vign.no.title[7]) 
    
    
    vign.cond_value = hash()
    vign.cond_value[['pijn']] <- list('1','4')
    vign.cond_value[['blijdschap']] <- list('2','5')
    vign.cond_value[['verdriet']] <- list('3','6')
    
    
    #set line types
    ltys<-c(1,4)
    ltys <- setNames(ltys, vign.cond_value[[vign.type]])
    
    
    # Show the guideline
    output$guideline <- renderText({
        get_guideline_vis(guideline_fp,1)
    })
    output$moreControls <- renderUI({
      tagList(
        checkboxGroupInput(NS(id,"vignette"),"Vignet",choiceNames = vign.cond_name[[vign.type]], choiceValues = vign.cond_value[[vign.type]], selected =vign.cond_value[[vign.type]][1]),
        checkboxGroupInput(NS(id,"respons"),"Respons",choices = as.character(unique(df.dataset()$respons)), selected =c("empathie") )
      )
      
    })
    
    
    cr <- reactive({
      a <- df.dataset()[as.character(df.dataset()$respons)%in%input$respons
                            & as.character(df.dataset()$vignet)%in%input$vignette & 
                              as.character(df.dataset()$vignet)%in% vign.cond_value[[vign.type]],]
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
      ggplot(cr(), aes(x=relatie, y=value.num, linetype=vignet, colour=respons)) + 
        geom_line(aes(group=interaction(vignet, respons)), size=2, alpha=0.5)+
        #geom_point(aes(shape=emotion)) +
        ggtitle(paste0("Dynamiek in relaties: ",vign.type)) +
        ylim(1,5)+ylab("Intensiteit") +
        My_Theme+
        scale_color_manual(values = respons.colorCode)+
        scale_linetype_manual(values = ltys)#c('Onderuit met de fiets':1, 'Een winnend lot':1,'Gezakt voor het examen':1,'Plat op het water':3,'Succes bij de Voice Kids':3,'Pesterij op straat':3))
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
