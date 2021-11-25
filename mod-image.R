source("questions.R")
imageUI <- function(id) {
  tagList(
    imageOutput(NS(id, "img"))
  )
}

imageServer <- function(id, situations_fp, counter) {
  moduleServer(id, function(input, output, session) {
    
    # Read list of described situations
    situations <- get_situations(situations_fp)
    
    get_image_name <-reactive({
      print(counter())
      ifelse(counter()<nrow(situations),
             situations[situations$Snum==counter(),c("Img")],
             situations[situations$Snum==0,c("Img")] ) 
    })
    
    output$img <- renderImage({
      list(src = get_image_name(),
           contentType = "image/jpg",
           width = "100%",
           height = "45%")},
      deleteFile = FALSE) 
    })
}

