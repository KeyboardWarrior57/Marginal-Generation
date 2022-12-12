installed.packages("rvest")

library("rvest")

installed.packages("dplyr")

library("dplyr")


linkFinalPricing = "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices/ByMonth"

pageFinalPricing = read_html(linkFinalPricing)


CSV_LinksFinalPricingAllYears <- pageFinalPricing %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


#rows <- CSV_LinksFinalPricingAllYears[27:38]
#dfFinalPricing2019 <- rbind(lapply(rows, read.csv()))

#i <- 27:38

for(i in 27:38){
  dftemp <- read.csv(paste0(CSV_LinksFinalPricingAllYears[i]))
  if (i == 27){
    df <- dftemp
  } else {
    dfFinalPricing2019 <- rbind(df, dftemp)
  }
}

