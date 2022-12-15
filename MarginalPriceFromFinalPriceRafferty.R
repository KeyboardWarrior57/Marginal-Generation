pacman::p_load(readxl, readr, dplyr, data.table, rvest)

dPath <- paste0(getwd(), '/Data/')

############################

linkFinalPricing <- "https://www.emi.ea.govt.nz/Wholesale/Datasets/DispatchAndPricing/FinalEnergyPrices/ByMonth"

pageFinalPricing <- read_html(linkFinalPricing)


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

dfFinalPrice <- df[df$TradingDate > as.Date('2012-12-31'),]
write_csv(dfFinalPrice, paste0(dPath, 'FinalPrices.csv'))

# once the above script has been run once, can load final prices with:
dfFinalPrice <- read_csv(paste0(dPath, 'FinalPrices.csv'))

colnames(dfFinalPrice) <- c("TradingDate","TradingPeriod", 
                            "PointOfConnection","DollarsPerMegawattHourFinal")

yearIndex <- 2019

linkOffers <- paste0('https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/',
                     as.character(yearIndex))

pageOffers <- read_html(linkOffers)

CSV_LinksOffers <- pageOffers %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


for(i in 1:length(CSV_LinksOffers)){
  dfOffers <- read_csv(paste0(CSV_LinksOffers[1]))
  dfJoined <- left_join(dfOffers,dfFinalPrice[dfFinalPrice$TradingDate == dfOffers$TradingDate[1], ]) # restrict FinalPrices to only date we have data for
  df <- dfJoined[dfJoined$DollarsPerMegawattHour <= dfJoined$DollarsPerMegawattHourFinal,]
  df <- df[df$Megawatts>0,]
  df <- df[df$ProductDescription == "Energy injected at a point of connection",]
  
  dfMarginal <- df %>%
    group_by(TradingDate,TradingPeriod, PointOfConnection) %>%
    summarise(MaxOffer = max(DollarsPerMegawattHour))
  
  dfFinalGIPMatch <- dfFinalPrice[dfFinalPrice$PointOfConnection %in% dfJoined$PointOfConnection,]
  # UP TO HERE - WORK IN PROGRESS
  
  if (i == 1){
    df <- dftemp
  } else {
    df <- rbind(df, dftemp)
  }
}


dfOffers <- df


dfJoined <- left_join(dfOffers,dfFinalPrice)

df <- dfJoined[dfJoined$DollarsPerMegawattHour <= dfJoined$DollarsPerMegawattHourFinal,]
df <- df[df$Megawatts>0,]
df <- df[df$ProductDescription == "Energy injected at a point of connection",]

dfMarginal <- df %>%
  group_by(TradingDate,TradingPeriod, PointOfConnection) %>%
  summarise(MaxOffer = max(DollarsPerMegawattHour))

dfFinalGIPMatch <- dfFinalPrice[dfFinalPrice$PointOfConnection %in% dfJoined$PointOfConnection,]




############################

dfFinalPrice <- read_excel(paste0(dPath, '20221112_FinalEnergyPrices.xlsx'))
#('20221112_Offers')

#dfOffers <- read_excel(paste0(dPath,'20221112_Offers.xlsx'))
dfOffers <- read_excel(paste0(dPath,"20221112_Offers.xlsx"), 
                       col_types = c("date", "numeric", "text", 
                                     "text", "text", "text", "text", "text", 
                                     "text", "numeric", "numeric", "numeric", 
                                     "text", "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric"))



dfJoined <- left_join(dfOffers,dfFinalPrice)

df <- dfJoined[dfJoined$DollarsPerMegawattHour <= dfJoined$DollarsPerMegawattHourFinal,]
df <- df[df$Megawatts>0,]
df <- df[df$ProductDescription == "Energy injected at a point of connection",]

dfMarginal <- df %>%
  group_by(TradingDate,TradingPeriod, PointOfConnection) %>%
  summarise(MaxOffer = max(DollarsPerMegawattHour))

dfFinalGIPMatch <- dfFinalPrice[dfFinalPrice$PointOfConnection %in% dfJoined$PointOfConnection,]

dfMarginalBEN <- dfMarginal[dfMarginal$PointOfConnection == 'BEN2202',]
dfBEN <- df[df$PointOfConnection == 'BEN2202', ]


# get one price for each TP from finalPrices
# Explore spread of these
# Then join so not having issue of joining GXP to GIP
# Create table where the closest GXP is assigned to its GIP

#df[df$DollarsPerMegawattHour == df$DollarsPerMegawattHourFinal,]

#trying to match lowest GXP price to same trading period offers
#dfFinalPrice <- data.frame(X20221112_FinalEnergyPrices)
MargPrice1 <- apply(dfFinalPrice, c(1, TradingPeriod == 1), which.min(dfFinalPrice$DollarsPerMegawattHour))
#doesnt seem to work trying with a 'if' function

MargPrice1 <- apply(dfFinalPrice, c(1, 2), if(TradingPeriod == 1) {which.min(DollarsPerMegawattHour)})
MargPrice1


MargPrice