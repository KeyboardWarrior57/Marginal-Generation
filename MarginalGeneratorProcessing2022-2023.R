pacman::p_load(readxl, readr, dplyr, data.table, rvest)

# Set data path
dPath <- paste0(here::here(), "/Data/")

linkFinalPricing <- "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices"     #URL from EMI website

pageFinalPricing <- read_html(linkFinalPricing)
                                                                                          ## Could add in an if, else function to see if you already have the file but only takes a couple of mins to download
                    
  CSV_LinksFinalPricingAllYears <- pageFinalPricing %>%                                            ##Saving csv from the website 
    html_nodes(".csv a") %>% 
    html_attr("href") %>% 
    paste("https://www.emi.ea.govt.nz",  ., sep="" )
  
  for (i in 1:length(CSV_LinksFinalPricingAllYears)){
    dftemp <- read_csv(paste0(CSV_LinksFinalPricingAllYears[i]))                                ##Reading the csv's and joining the outputs
    if (i == 1){
      df <- dftemp
    } else {
      df <- rbind(df, dftemp)
    }
  }
  
  dfFinalPrice <- df
  write_csv(dfFinalPrice, paste0(dPath, 'FinalPrices.csv'))                           ## Saving csv of final pricings to dpath location


colnames(dfFinalPrice) <- c("TradingDate","TradingPeriod",                                       
                            "GXP","DollarsPerMegawattHourFinal")                      # Changing col names to make it less confusing



for (yearIndex in c(2022, 2023)) {
  print(paste('Year', yearIndex))                                                     ## creating a for loop for different years to read offer sheets
  linkOffers <-
    paste0(
      'https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/',
      as.character(yearIndex)
    )
  
  pageOffers <- read_html(linkOffers)
  
  CSV_LinksOffers <- pageOffers %>%                                                   ## Pulling offer sheet csv's
    html_nodes(".csv a") %>%
    html_attr("href") %>%
    paste("https://www.emi.ea.govt.nz",  ., sep = "")
  
  
  for (i in 1:length(CSV_LinksOffers)) {
    print(paste('Day', i))
    dfOffers <- read_csv(paste(CSV_LinksOffers[i]))                                     #Reading csv's
    dfOffers <- rename(dfOffers, 'Generator' = 'PointOfConnection')
    dfJoined <- left_join(dfOffers, dfFinalPrice, multiple = "all") %>%                 #Joining offers and final prices, "multiple = all" included because it wouldn't work witout it
      filter(ProductType == 'Energy') %>%
      filter(DollarsPerMegawattHour > 0) %>%
      filter(DollarsPerMegawattHour == DollarsPerMegawattHourFinal)                     #Filtering for energy offers above $0 only and then setting $offer and $Final prices equal
    dfMarginal <- dfJoined %>%
      select(TradingDate, TradingPeriod, Generator, DollarsPerMegawattHour, GXP) %>%     #Only keeping columns we want and getting rid of duplicates with distinct() function
      distinct()
    dfFinalTemp <- dfMarginal %>%
      filter(Generator == GXP)                                                           #Only keeping rows where GIP and GXP are the same, Gets rid of situations that involve grid constraints
    
    if (i == 1) {
      dfFinal <- dfFinalTemp
    } else {
      dfFinal <- rbind(dfFinal, dfFinalTemp)                                              #Joining the final marginal generator files
      if (i == length(CSV_LinksOffers)) {
        write_csv(dfFinal,
                  paste0(
                    dPath,
                    'MarginalGenerator',                                                 #saving csv's of marginal generators to dpath location
                    as.character(yearIndex),
                    '.csv'
                  ))
      }
      
    }
  }
}


#####New Zealand now uses, (as of roughly january 2023) a dispatch pricing method in the spot market, hence there can be different marginal generators for different
# dispatch periods of each trading period. 
# The offers for different dispatch periods of a trading period can still be found in the offer sheets, however the final prices are calculated as
# a time weighted average of all final prices within trading period. 
# EMI doesn't publish the final prices for each dispatch period within a trading period, however they must have the data somewhere because they use it 
# to calculate the TWA final prices.
# To calculate the marginal generator for past Jan 2023 you'll need to get hold of the final prices for different dispatch periods within each trading 
# period from EMI somehow, preferably a big csv for all of them. 
# Then you could just use "filter(TimeFinal == TimeOffer)" or something similar to filter the final pricing and offers for the same dispatch period within
# each trading period. 
# I'd also use a time weighted average to calculate the carbon intensity for each trading period. 
