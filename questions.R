library(reshape)
respons_items <- c("empathie","counter","distress","compassie","gedrag")
relationship_items <- c("vriend(in)","vreemde","vijand")

style_txt_itms <- function(txt){
  strong(p(style="text-align: justify;",
           txt,
           style = "font-family: 'Tahoma'; font-si116pt; font-weight: 400;"
  ))
  
}

get_introduction <- function(intro_fp){
  # Read the survey_introduction
  df_intro <- read.csv(intro_fp)
  
  return (
      lapply(df_intro[,c('Paragraph')],style_txt_itms)
    )

}

get_vignettes <- function(stu_fp){
  # Read the list of vignettes
  df_stu <- read.csv(stu_fp)
  return (
    df_stu
  )
  
}

filter_vignettes <- function(df_vignettes){
  
  vignette_numbers_all <- c(1, 4, 7, 10, 13, 16)
  vignette_numbers_main <- 1:6
  # Use logical indexing to filter rows
  selected_rows <- df_vignettes[df_vignettes$Vnum %in% vignette_numbers_all, ]
  
  selected_rows$Vnum <- vignette_numbers_main[match(selected_rows$Vnum, vignette_numbers_all)]
  
  # View the selected rows
  print(selected_rows)
  return(
    selected_rows
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

get_disclaimer <- function(disclaimer_fp) {
  config <- read.csv(disclaimer_fp)
  as.list(setNames(config$value, config$key))
}

make.df.survey_result<- function(vignette.no,respons.no){
  relationship.no <- length(relationship_items)
  vignet <-  rep(seq(1,vignette.no/relationship.no), each = relationship.no)
  relatie <- rep(relationship_items,times=relationship.no)
  df.survey.result <- data.frame(vignet,relatie)
  
  em.names <- respons_items
  emval <- rep("", nrow(df.survey.result))
  em<-as.data.frame(matrix(emval, nrow=length(emval), ncol=respons.no))
  colnames(em)<- em.names
  
  df <- cbind(df.survey.result,em)
  
  df$relatie <- factor(df$relatie, levels = c("vriend(in)","vreemde","vijand") )
  df$vignet <- factor(df$vignet)
  
  # add 'vign_cat', to show pain, sad and happiness
  cond_pain <- (df$vignet =='1') | (df$vignet =='4')
  df[cond_pain,"vign_cat"] <-"pijn"
  
  cond_happy <- (df$vignet =='2') | (df$vignet =='5')
  df[cond_happy,"vign_cat"] <-"blijdschap"
  
  cond_sad <- (df$vignet =='3') | (df$vignet =='6')
  df[cond_sad,"vign_cat"] <-"verdriet"
  
  df$vign_cat <- factor(df$vign_cat, levels = c("blijdschap","verdriet","pijn") )
  print(df)
  return(df)
  
}

nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

refactor_df <- function(df){
  # wide.to.long 
  long <- melt(df, id=c("vignet","relatie","vign_cat"))
  names(long) <- c("vignet","relatie","vign_cat","respons","value")

  long$value<- factor(long$value, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk") )
  long$value.num <- as.numeric(long$value)
  return(long)
}

to_numeric_df <- function(df){
  df$empathie_<- as.integer(factor(df$empathie, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk")))
  
  df$compassie_<- as.integer(factor(df$compassie, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk")))

  df$distress_<- as.integer(factor(df$distress, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk") ))
  
  df$gedrag_<- as.integer(factor(df$gedrag, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk") ))
  
  df$counter_<- as.integer(factor(df$counter, levels = c("helemaal niet","een beetje","redelijk","sterk","heel sterk") ))
  
  cols <- c('vignet','relatie','vign_cat','empathie_','counter_', 'distress_','compassie_',  'gedrag_' )
  return(df[,cols])
  
}

get_ending <- function(end_fp){
  # Read the survey_ending
  df_ending <- read.csv(end_fp)
  return (df_ending)
  
}