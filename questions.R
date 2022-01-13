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

get_situations <- function(stu_fp){
  # Read the list of situations
  df_stu <- read.csv(stu_fp)
  return (
    df_stu
  )
  
}

get_sub_situations <- function(sub_stu_fp){
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

make.df.survey_result<- function(situation.no, sub.situation.no,question.no){
  
  situation <-  rep(seq(1,situation.no), each = sub.situation.no)
  sub.situation <- rep(seq(1,sub.situation.no),times=situation.no)
  df.survey.result <- data.frame(situation,sub.situation)
  
  q.names <- paste0('q',seq(1,question.no))
  qval <- rep("", nrow(df.survey.result))
  q<-as.data.frame(matrix(qval, nrow=length(qval), ncol=question.no))
  colnames(q)<- q.names
  
  return <- cbind(df.survey.result,q)
  
}

nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}
