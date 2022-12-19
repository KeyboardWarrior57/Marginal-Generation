pacman::p_load(readxl, readr, dplyr, data.table, rvest)

dPath <- paste0(getwd(), '/Data/')
#dPath <- paste0('L:/DuncanFulton/Marginal-Generation/Data/')


############################

linkFinalPricing <- "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices/ByMonth"

pageFinalPricing <- read_html(linkFinalPricing)

if (file.exists(paste0(dPath,  # Check if final prices already downloaded
                       'FinalPrices.csv'))){ 
  dfFinalPrice <- read_csv(paste0(dPath, 'FinalPrices.csv'))
} else {                       # If they are not, download them
  CSV_LinksFinalPricingAllYears <- pageFinalPricing %>% 
    html_nodes(".csv a") %>% 
    html_attr("href") %>% 
    paste("https://www.emi.ea.govt.nz",  ., sep="" )
  
  for (i in 1:110){
    dftemp <- read_csv(paste0(CSV_LinksFinalPricingAllYears[i]))
    if (i == 1){
      df <- dftemp
    } else {
      df <- rbind(df, dftemp)
    }
  }
  
  dfFinalPrice <- df
  write_csv(dfFinalPrice, paste0(dPath, 'FinalPrices.csv'))
}

colnames(dfFinalPrice) <- c("TradingDate","TradingPeriod", 
                            "GXP","DollarsPerMegawattHourFinal")

#yearIndex <- 2019

for (yearIndex in c(2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) {
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
    dfJoined <- left_join(dfOffers, dfFinalPrice) %>%
      filter(ProductType == 'Energy') %>%
      filter(DollarsPerMegawattHour > 0) %>%
      filter(DollarsPerMegawattHour <= DollarsPerMegawattHourFinal)
    dfMarginal <- dfJoined %>%
      group_by(TradingDate,
               TradingPeriod,
               GXP) %>%
      summarise(DollarsPerMegawattHour = max(DollarsPerMegawattHour))
    dfFinalTemp <-
      left_join(dfMarginal, dfJoined[, c(
        'GXP',
        'DollarsPerMegawattHour',
        'TradingPeriod',
        'TradingDate',
        'ParticipantCode',
        'Generator'
      )]) %>%
      distinct()
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



#for(i in 1:length(CSV_LinksOffers)){
 # dfOffers <- read_csv(paste0(CSV_LinksOffers[1]))
  #dfJoined <- left_join(dfOffers,dfFinalPrice[dfFinalPrice$TradingDate == dfOffers$TradingDate[1], ]) # restrict FinalPrices to only date we have data for
  #df <- dfJoined[dfJoined$DollarsPerMegawattHour <= dfJoined$DollarsPerMegawattHourFinal,]
  #df <- df[df$Megawatts>0,]
  #df <- df[df$ProductDescription == "Energy injected at a point of connection",]}
  # 
  # dfMarginal <- df %>%
  #   group_by(TradingDate,TradingPeriod, PointOfConnection, PointofConnectionFinal) %>%
  #   summarise(MaxOffer = max(DollarsPerMegawattHour))
  # 
  # dfFinalGIPMatch <- dfFinalPrice[dfFinalPrice$PointOfConnection %in% dfJoined$PointOfConnection,]