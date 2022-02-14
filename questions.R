library(data.table)

emotion_items <- c("empathie","sympathie","distress","gedrag","counter-empathie")
relationship_items <- c("friend","stranger","foe")
style_txt_itms <- function(txt){
  strong(p(style="text-align: justify;",
           txt,
           style = "font-family: 'times'; font-si18pt"
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
  # Read the list of situations
  df_stu <- read.csv(stu_fp)
  return (
    df_stu
  )
  
}

get_relationships <- function(sub_stu_fp){
  # Read the list of situations
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
  
  vignette <-  rep(seq(1,vignette.no), each = relationship.no)
  #sub.situation <- rep(seq(1,sub.situation.no),times=situation.no)
  relationship <- rep(relationship_items,times=relationship.no)
  df.survey.result <- data.frame(vignette,relationship)
  
  #q.names <- paste0('q',seq(1,question.no))
  em.names <- emotion_items
  emval <- rep("", nrow(df.survey.result))
  em<-as.data.frame(matrix(emval, nrow=length(emval), ncol=emotion.no))
  colnames(em)<- em.names
  df <- cbind(df.survey.result,em)
   
  df$relationship <- factor(df$relationship, levels = c("friend","stranger","foe") )
  df$vignette <- factor(df$vignette)
  return(df)
  
}

nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

refactor_df <- function(df){
  # wide.to.long 
  long <- melt(setDT(df), id.vars=c("vignette","relationship"))
  names(long) <- c("vignette","relationship","emotion","value")
  
  # string -> categorical with specific levels -> number
  long$value<- factor(long$value, levels = c("helemaal niet","een beetje","redelijk goed","sterk","heel sterk") )
  long$value.num <- as.numeric(long$value)
  
  return(long)
}
