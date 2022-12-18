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
                            "PointOfConnectionFinal","DollarsPerMegawattHourFinal")


#dfFinalPrice$TradingDate <- as.character(dfFinalPrice$TradingDate)

yearIndex <- 2019

linkOffers <- paste0('https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/',
                     as.character(yearIndex))

pageOffers <- read_html(linkOffers)

CSV_LinksOffers <- pageOffers %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )

# for(i in 1:length(CSV_LinksOffers)) {                             
#   assign(paste0("data", i),                                 
#          read_csv(paste(CSV_LinksOffers[i])))}

# PointofConnectionFinal is GXP

#####################################################
# dfJoined <- left_join(df_temp, dfFinalPrice)
# 
# 
# dfMarginal <- dfJoined[dfJoined$DollarsPerMegawattHour <= 
#                          dfJoined$DollarsPerMegawattHourFinal,] 
# 
# dfMarginalAbove0 <-  dfMarginal[dfMarginal$DollarsPerMegawattHour > 0,]
# 
# dfMarginalAbove0$Difference <- (dfMarginalAbove0$DollarsPerMegawattHourFinal - 
#                                   dfMarginalAbove0$DollarsPerMegawattHour)
# 
# dfMarginalEnergy <- dfMarginalAbove0 %>%
#   filter(ProductType == 'Energy')
# 
# dfMinsAll <- dfMarginalEnergy %>%
#   select(
#     TradingDate,
#     TradingPeriod,
#     DollarsPerMegawattHourFinal,
#     PointOfConnection,
#     PointOfConnectionFinal,
#     Difference
#   ) %>%
#   group_by(TradingPeriod,
#            TradingDate,
#            PointOfConnectionFinal,
#            PointOfConnection) %>%
#   summarise(Difference = min(Difference))
# 
# dfMarginalGenerators <- left_join(dfMinsAll, dfMarginalEnergy)
# 
# dfMarginalGeneratorsDistinct <-  dfMarginalGenerators%>%
#   distinct(TradingPeriod, TradingDate, PointOfConnectionFinal, PointOfConnection)
#################################



i <- 1
for (i in 1:length(CSV_LinksOffers)) {
  df_temp <- read_csv(paste(CSV_LinksOffers[i]))
  
  dfJoined <- left_join(df_temp, dfFinalPrice) %>%
    filter(ProductType == 'Energy') %>%
    filter(DollarsPerMegawattHour > 0) %>%
    filter(DollarsPerMegawattHour <= DollarsPerMegawattHourFinal)
  dfMarginal <- dfJoined %>%
    group_by(TradingDate,
             TradingPeriod,
             PointOfConnectionFinal,
             DollarsPerMegawattHour) %>%
    summarise(MaxOffer = max(DollarsPerMegawattHour),
              PointOfConnection = PointOfConnection) %>%
    group_by(TradingPeriod,
             TradingDate,
             PointOfConnectionFinal,
             PointOfConnection) %>%
    distinct()
  
}


 
  
#for(i in 1:length(CSV_LinksOffers)){
 # dfOffers <- read_csv(paste0(CSV_LinksOffers[1]))
  #dfJoined <- left_join(dfOffers,dfFinalPrice[dfFinalPrice$TradingDate == dfOffers$TradingDate[1], ]) # restrict FinalPrices to only date we have data for
  #df <- dfJoined[dfJoined$DollarsPerMegawattHour <= dfJoined$DollarsPerMegawattHourFinal,]
  #df <- df[df$Megawatts>0,]
  #df <- df[df$ProductDescription == "Energy injected at a point of connection",]}
  
  dfMarginal <- df %>%
    group_by(TradingDate,TradingPeriod, PointOfConnection, PointofConnectionFinal) %>%
    summarise(MaxOffer = max(DollarsPerMegawattHour))
  
  dfFinalGIPMatch <- dfFinalPrice[dfFinalPrice$PointOfConnection %in% dfJoined$PointOfConnection,]