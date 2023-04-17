pacman::p_load(readxl, readr, dplyr, data.table, rvest)

# Set data path
dPath <- paste0(here::here(), "/Data/")

linkFinalPricing <- "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices/ByMonth"      #URL from EMI website

pageFinalPricing <- read_html(linkFinalPricing)

if (file.exists(paste0(dPath,                                          # Check if final prices already downloaded
                       'FinalPrices.csv'))){ 
  dfFinalPrice <- read_csv(paste0(dPath, 'FinalPrices.csv'))
} else {                                                              # If they are not, download them
  CSV_LinksFinalPricingAllYears <- pageFinalPricing %>% 
    html_nodes(".csv a") %>% 
    html_attr("href") %>% 
    paste("https://www.emi.ea.govt.nz",  ., sep="" )
  
  for (i in 1:110){
    dftemp <- read_csv(paste0(CSV_LinksFinalPricingAllYears[i]))          #Joining in a total csv for all 8 years
    if (i == 1){
      df <- dftemp
    } else {
      df <- rbind(df, dftemp)
    }
  }
  
  dfFinalPrice <- df
  write_csv(dfFinalPrice, paste0(dPath, 'FinalPrices.csv'))                #Saving csv to dPath location 
}

colnames(dfFinalPrice) <- c("TradingDate","TradingPeriod",                   #Changing colnames to make more sense
                            "GXP","DollarsPerMegawattHourFinal")

#yearIndex <- 2019

for (yearIndex in c(2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) {            #Creating a for loop for what years you want, final prices only go back till 2013, EMI would probably have more though
  print(paste('Year', yearIndex))
  linkOffers <-
    paste0(
      'https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/',      #URL from EMI for offer sheets
      as.character(yearIndex)
    )
  
  pageOffers <- read_html(linkOffers)
  
  CSV_LinksOffers <- pageOffers %>%                                             # Creating csvs of offers for a year at a time
    html_nodes(".csv a") %>%
    html_attr("href") %>%
    paste("https://www.emi.ea.govt.nz",  ., sep = "")
  
  
  for (i in 1:length(CSV_LinksOffers)) {
    print(paste('Day', i))
    dfOffers <- read_csv(paste(CSV_LinksOffers[i]))                             #Reading offer csvs 
    dfOffers <- rename(dfOffers, 'Generator' = 'PointOfConnection')
    dfJoined <- left_join(dfOffers, dfFinalPrice) %>%
      filter(ProductType == 'Energy') %>%
      filter(DollarsPerMegawattHour > 0) %>%
      filter(DollarsPerMegawattHour == DollarsPerMegawattHourFinal)                    # Filtering for energy bids above $0 and where final price = offer price
    dfMarginal <- dfJoined %>%
      select(TradingDate, TradingPeriod, Generator, DollarsPerMegawattHour, GXP) %>%
      distinct()
    dfFinalTemp <- dfMarginal %>%
      filter(Generator == GXP)                                                          #Filtering so GXP = GIP
    
    if (i == 1) {
      dfFinal <- dfFinalTemp
    } else {
      dfFinal <- rbind(dfFinal, dfFinalTemp)
      if (i == length(CSV_LinksOffers)) {                                              # Joining the outputs 
        write_csv(dfFinal,
                  paste0(                                                             # saving csv's of marginal generators to dpath location 
                    dPath,
                    'MarginalGenerator',
                    as.character(yearIndex),
                    '.csv'
                  ))
      }
      
    }
  }
}
