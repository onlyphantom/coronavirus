tolong <- function(data){
  data$date <- as.Date(data$date)
  vs <- data[,c("confirmed", "suspected", "cured", "dead")]
  dat <- aggregate(vs, by=data[,c("date", "countryCode")], FUN=sum)
  long <- reshape2::melt(data=dat,
                        id.vars=c("date", "countryCode"),
                        measured.vars=c("confirmed", "suspected", "dispatched", "dead"))
}