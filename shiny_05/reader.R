library(dplyr)

cleanSingle <- function(x){
  x %>%
    select(-Province.State, -Lat, -Long) %>% 
    gather(key="date", value="Value", -Country.Region) %>% 
    group_by(Country.Region, date) %>% 
    summarise("Value"=sum(Value)) %>% 
    ungroup() %>% 
    select(date, "country"=Country.Region, Value) %>% 
    mutate(date, date=as.Date(substring(date, 2, nchar(date)),"%m.%d.%y"))
}

read_github <- function(){
  # Load most updated data
  confirmed_w <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")
  deaths_w <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv")
  recovered_w <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv")
  res <- list(confirmed_w, deaths_w, recovered_w) %>% 
    lapply(cleanSingle) %>% 
    reduce(left_join,by = c("date", "country"))
  
  colnames(res)[3:5] <- c("confirmed", "deaths", "recovered")
  
  return(res)  
}

