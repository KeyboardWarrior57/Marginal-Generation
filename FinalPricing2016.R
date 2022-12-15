linkFinalPricing = "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices/ByMonth"

pageFinalPricing = read_html(linkFinalPricing)


CSV_LinksFinalPricingAllYears <- pageFinalPricing %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


#i <- 63:74

start_index = 63
for(i in start_index:74){
  dftemp <- read.csv(paste0(CSV_LinksFinalPricingAllYears[i]))
  if (i == start_index){
    df <- dftemp
  } else {
    df <- rbind(df, dftemp)
  }
}

dfFinalPricing2016 <-  df


readr::write_csv(dfFinalPricing2016, paste0(dPath, 'FinalPricing2016.csv'))
