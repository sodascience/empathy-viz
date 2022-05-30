My_Theme = theme(
  plot.title = element_text(size = 20,face="bold", margin = margin(10,0,10,0), hjust = 0.5),
  axis.title.x = element_blank(),
  axis.text.x = element_text(size = 14,face="bold"),
  axis.title.y = element_text(size = 12, margin = margin(t=0, r=20, b=0, l=0)),
  axis.text.y = element_text(size = 12, face="bold"),
  legend.title = element_text(size = 12, face="bold"),
  legend.text = element_text(size = 14),
  panel.grid.major.x = element_blank())

theme_set(theme_minimal())

respons.colorCode <- c("empathie"="#003BA3","counter"="#242424","distress"="#D64933","sympathie"="#05B158","gedrag"="#880043")
#ltys <- c('Onderuit met de fiets':1, 'Een winnend lot':1,'Gezakt voor het examen':1,'Plat op het water':3,'Succes bij de Voice Kids':3,'Pesterij op straat':3)

get_guideline_vis <- function(guideline_fp, gno){
  # Read the list of vignettes
  df_guideline <- read.csv(guideline_fp)

  return (
    df_guideline[df_guideline$GNum==gno,"Text"]
  )
}