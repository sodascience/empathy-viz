library(reshape)
emotion_items <- c("empathie","sympathie","distress","gedrag","counter")
relationship_items <- c("vriend","vreemde","vijand")

style_txt_itms <- function(txt){
  strong(p(style="text-align: justify;",
           txt,
           style = "font-family: 'Tahoma'; font-si116pt; font-weight: 400;"
  ))
  
}

get_introduction <- function(intro_fp, part_no){
  # Read the survey_introduction
  df_intro <- read.csv(intro_fp)
  if (part_no ==1)
    cond <- df_intro$PNum ==1
  else
    cond <- df_intro$PNum !=1
  return (
      lapply(df_intro[cond,c('Paragraph')],style_txt_itms)
    )

}

get_vignettes <- function(stu_fp){
  # Read the list of vignettes
  df_stu <- read.csv(stu_fp)
  return (
    df_stu
  )
  
}

get_relationships <- function(sub_stu_fp){
  # Read the list of vignettes
  df_sub_stu <- read.csv(sub_stu_fp)
  return (
    df_sub_stu
  )
  
}
get_radioMatrixFrame <- function(rmf_fp){
  # Read the radioMatrix rows and columns
  df_rmf <- read.csv(rmf_fp)
  return(
    df_rmf
  )
}

make.df.survey_result<- function(vignette.no, relationship.no,emotion.no){
  
  vignet <-  rep(seq(1,vignette.no), each = relationship.no)
  relatie <- rep(relationship_items,times=relationship.no)
  df.survey.result <- data.frame(vignet,relatie)
  
  em.names <- emotion_items
  emval <- rep("", nrow(df.survey.result))
  em<-as.data.frame(matrix(emval, nrow=length(emval), ncol=emotion.no))
  colnames(em)<- em.names
  
  df <- cbind(df.survey.result,em)
  
  df$relatie <- factor(df$relatie, levels = c("vriend","vreemde","vijand") )
  df$vignet <- factor(df$vignet)
  
  # add 'vign_cat', to show pain, sad and happiness
  cond_pain <- (df$vignet =='1') | (df$vignet =='4')
  df[cond_pain,"vign_cat"] <-"pijn"
  
  cond_happy <- (df$vignet =='2') | (df$vignet =='5')
  df[cond_happy,"vign_cat"] <-"blijdschap"
  
  cond_sad <- (df$vignet =='3') | (df$vignet =='6')
  df[cond_sad,"vign_cat"] <-"verdriet"
  
  df$vign_cat <- factor(df$vign_cat, levels = c("blijdschap","pijn","verdriet") )
  return(df)
  
}

nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

refactor_df <- function(df){
  # wide.to.long 
  long <- melt(df, id=c("vignet","relatie","vign_cat"))
  names(long) <- c("vignet","relatie","vign_cat","emotie","value")

  long$value<- factor(long$value, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk") )
  long$value.num <- as.numeric(long$value)
  return(long)
}

to_numeric_df <- function(df){
  df$empathie_<- as.integer(factor(df$empathie, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk")))
  
  df$sympathie_<- as.integer(factor(df$sympathie, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk")))

  df$distress_<- as.integer(factor(df$distress, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk") ))
  
  df$gedrag_<- as.integer(factor(df$gedrag, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk") ))
  
  df$counter_<- as.integer(factor(df$counter, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk") ))
  
  cols <- c('vignet','relatie','vign_cat','empathie_', 'sympathie_', 'distress_', 'gedrag_', 'counter_')
  return(df[,cols])
  
}

get_ending <- function(end_fp){
  # Read the survey_ending
  df_ending <- read.csv(end_fp)
  return (df_ending)
  
}