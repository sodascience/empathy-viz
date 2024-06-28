# This file is part of Empathy-viz.

# Copyright (C) 2024  Minet de Wied & SodaScience

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
