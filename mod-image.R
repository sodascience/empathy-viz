source("questions.R")
imageUI <- function(id) {
  tagList(
    imageOutput(NS(id, "img"))
  )
}

imageServer <- function(id, vignettes_fp, counter) {
  moduleServer(id, function(input, output, session) {
    
    # Read list of described situations
    vignettes <- get_vignettes(vignettes_fp)
    
    get_image_name <-reactive({
      print(counter())
      ifelse(counter()<nrow(vignettes),
             vignettes[vignettes$Vnum==counter(),c("Img")],
             vignettes[vignettes$Vnum==0,c("Img")] ) 
    })
    
    output$img <- renderImage({
      list(src = get_image_name(),
           contentType = "image/jpg",
           width = "100%",
           height = "45%")},
      deleteFile = FALSE) 
    })
}

