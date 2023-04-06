# This function calculates the average carbon intensity
# for each season in the data provided to it

SeasonAvIntensity <- function(df){
  dfSummer <- df %>%
    filter(Season == "Summer") %>%
    group_by(TradingPeriod) %>%
    summarise(av = mean(CarbonIntensity)) %>%
    mutate(Season = "Summer")
  
  dfAutumn <- df %>%
    filter(Season == "Autumn") %>%
    group_by(TradingPeriod) %>%
    summarise(av = mean(CarbonIntensity)) %>%
    mutate(Season = "Autumn")
  
  dfWinter <- df %>%
    filter(Season == "Winter") %>%
    group_by(TradingPeriod) %>%
    summarise(av = mean(CarbonIntensity)) %>%
    mutate(Season = "Winter")
  
  dfSpring <- df %>%
    filter(Season == "Spring") %>%
    group_by(TradingPeriod) %>%
    summarise(av = mean(CarbonIntensity)) %>%
    mutate(Season = "Spring")
  
  dfSeasonAvIntensity <- rbind(dfAutumn, dfSpring, dfSummer, dfWinter)
  return(dfSeasonAvIntensity)
}




