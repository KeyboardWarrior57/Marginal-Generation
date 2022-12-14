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


rows <- CSV_LinksFinalPricingAllYears[27:38]
dfFinalPricing2019 <- rbind(lapply(rows, read.csv()))

#i <- 27:38

start_index = 27
for(i in start_index:38){
  dftemp <- read.csv(paste0(CSV_LinksFinalPricingAllYears[i]))
  if (i == start_index){
    df <- dftemp
  } else {
    df <- rbind(df, dftemp)
  }
}

dfFinalPricing2019 <- df


readr::write_csv(dfFinalPricing2019, paste0(dPath, 'FinalPricing2019.csv'))



