grim <- theme_minimal() + theme(
  panel.background = element_rect(fill="black"),
  plot.background = element_rect(fill="black"),
  legend.background = element_blank(),
  legend.key = element_blank(),
  legend.text = element_text(color = "white"),
  plot.title = element_text(color = "white", face = "bold"),
  axis.title = element_text(color = "white"),
  axis.text = element_text(color = "white")
)

starbucks <- grim + theme(
  panel.background = element_rect(fill="#006341", color="black"),
  plot.background = element_rect(fill="#006341", color="black")
)