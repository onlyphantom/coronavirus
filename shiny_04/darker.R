library(ggthemes)
grim <- theme_fivethirtyeight() + theme(
  panel.background = element_rect(fill="black"),
  plot.background = element_rect(fill="black"),
  legend.background = element_blank(),
  legend.key = element_blank(),
  legend.text = element_text(color = "white"),
  plot.title = element_text(color = "white", face = "bold"),
  axis.title = element_text(color = "white"),
  axis.text = element_text(color = "white")
)