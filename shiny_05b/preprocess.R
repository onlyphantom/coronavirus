library(reshape2)

tolong <- function(data){
  data %>% melt(
    id.vars=c("date", "country"),
    measured.vars=c("confirmed", "recovered", "dead"))
}