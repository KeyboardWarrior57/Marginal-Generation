pacman::p_load(readxl, readr, dplyr, data.table, rvest)

dPath <- paste0(getwd(), '/Data/')
#dPath <- paste0('L:/DuncanFulton/Marginal-Generation/Data/')

#  Add in a dPath !!!

############################

linkFinalPricing <- "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices"

pageFinalPricing <- read_html(linkFinalPricing)

                    
  CSV_LinksFinalPricingAllYears <- pageFinalPricing %>% 
    html_nodes(".csv a") %>% 
    html_attr("href") %>% 
    paste("https://www.emi.ea.govt.nz",  ., sep="" )
  
  for (i in 1:length(CSV_LinksFinalPricingAllYears)){
    dftemp <- read_csv(paste0(CSV_LinksFinalPricingAllYears[i]))
    if (i == 1){
      df <- dftemp
    } else {
      df <- rbind(df, dftemp)
    }
  }
  
  dfFinalPrice <- df
  write_csv(dfFinalPrice, paste0(dPath, 'FinalPrices.csv'))
#}

colnames(dfFinalPrice) <- c("TradingDate","TradingPeriod", 
                            "GXP","DollarsPerMegawattHourFinal")



for (yearIndex in c(2022, 2023)) {
  print(paste('Year', yearIndex))
  linkOffers <-
    paste0(
      'https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/',
      as.character(yearIndex)
    )
  
  pageOffers <- read_html(linkOffers)
  
  CSV_LinksOffers <- pageOffers %>%
    html_nodes(".csv a") %>%
    html_attr("href") %>%
    paste("https://www.emi.ea.govt.nz",  ., sep = "")
  
  
  for (i in 1:length(CSV_LinksOffers)) {
    print(paste('Day', i))
    dfOffers <- read_csv(paste(CSV_LinksOffers[i]))
    dfOffers <- rename(dfOffers, 'Generator' = 'PointOfConnection')
    dfJoined <- left_join(dfOffers, dfFinalPrice, multiple = "all") %>%
      filter(ProductType == 'Energy') %>%
      filter(DollarsPerMegawattHour > 0) %>%
      filter(DollarsPerMegawattHour == DollarsPerMegawattHourFinal)
    dfMarginal <- dfJoined %>%
      select(TradingDate, TradingPeriod, Generator, DollarsPerMegawattHour, GXP) %>%
      distinct()
    dfFinalTemp <- dfMarginal %>%
      filter(Generator == GXP)
    
    if (i == 1) {
      dfFinal <- dfFinalTemp
    } else {
      dfFinal <- rbind(dfFinal, dfFinalTemp)
      if (i == length(CSV_LinksOffers)) {
        write_csv(dfFinal,
                  paste0(
                    dPath,
                    'MarginalGenerator',
                    as.character(yearIndex),
                    '.csv'
                  ))
      }
      
    }
  }
}