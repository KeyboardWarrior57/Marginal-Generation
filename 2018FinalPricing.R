installed.packages("rvest")
dPath <- paste0('L:/DuncanFulton/Marginal-Generation/Data/')

library("rvest")

installed.packages("dplyr")

library("dplyr")


linkFinalPricing = "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices/ByMonth"

pageFinalPricing = read_html(linkFinalPricing)


CSV_LinksFinalPricingAllYears <- pageFinalPricing %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )




#i <- 39:50

start_index = 39
for(i in start_index:50){
  dftemp <- read.csv(paste0(CSV_LinksFinalPricingAllYears[i]))
  if (i == start_index){
    df <- dftemp
  } else {
    df <- rbind(df, dftemp)
  }
}

dfFinalPricing2018 <- df

readr::write_csv(dfFinalPricing2018, paste0(dPath, 'FinalPricing2018.csv'))


#rows <- CSV_LinksFinalPricingAllYears[27:38]
#dfFinalPricing2019 <- rbind(lapply(rows, read.csv()))
