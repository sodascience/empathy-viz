My_Theme = theme(
  plot.title = element_text(size = 20,face="bold", margin = margin(10,0,10,0), hjust = 0.5),
  axis.title.x = element_blank(),
  axis.text.x = element_text(size = 14,face="bold"),
  axis.title.y = element_text(size = 12, margin = margin(t=0, r=20, b=0, l=0)),
  axis.text.y = element_text(size = 12, face="bold"),
  legend.title = element_text(size = 12, face="bold"),
  legend.text = element_text(size = 14))

theme_set(theme_minimal())