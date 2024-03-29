source("questions.R")
imageUI <- function(id) {
  tagList(
    imageOutput(NS(id, "img"))
  )
}

imageServer <- function(id, vignettes_fp, counter) {
  moduleServer(id, function(input, output, session) {
    
    # Read list of described vignettes
    vignettes <- get_vignettes(vignettes_fp)
    
    get_image_name <-reactive({
      print(counter())
      if((counter()<1)||(counter()>=nrow(vignettes))){
        vignettes[vignettes$Vnum==0,c("Img")] 
      }else{
        vignettes[vignettes$Vnum==counter(),c("Img")]
      }
    })
    
    output$img <- renderImage({
      list(src = get_image_name(),
           contentType = "image/jpg",
           width = "95%")},
      deleteFile = FALSE) 
    })
}

