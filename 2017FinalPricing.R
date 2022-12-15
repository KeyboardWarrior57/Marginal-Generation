

linkFinalPricing = "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices/ByMonth"

pageFinalPricing = read_html(linkFinalPricing)


CSV_LinksFinalPricingAllYears <- pageFinalPricing %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


#i <- 51:62

start_index = 51
for(i in start_index:62){
  dftemp <- read.csv(paste0(CSV_LinksFinalPricingAllYears[i]))
  if (i == start_index){
    df <- dftemp
  } else {
    df <- rbind(df, dftemp)
  }
}

dfFinalPricing2017 <-  df


readr::write_csv(dfFinalPricing2017, paste0(dPath, 'FinalPricing2017.csv'))