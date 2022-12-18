pacman::p_load(readxl, readr, dplyr, data.table, rvest)

dPath <- paste0(getwd(), '/Data/')
dPath <- paste0('L:/DuncanFulton/Marginal-Generation/Data/')


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

dfFinalPrice <- df
write_csv(dfFinalPrice, paste0(dPath, 'FinalPrices.csv'))

# once the above script has been run once, can load final prices with:
dfFinalPrice <- read_csv(paste0(dPath, 'FinalPrices.csv'))

colnames(dfFinalPrice) <- c("TradingDate","TradingPeriod", 
                            "PointOfConnectionFinal","DollarsPerMegawattHourFinal")


dfFinalPrice$TradingDate <- as.character(dfFinalPrice$TradingDate)

yearIndex <- 2019

linkOffers <- paste0('https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/',
                     as.character(yearIndex))

pageOffers <- read_html(linkOffers)

CSV_LinksOffers <- pageOffers %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


for(i in 1:length(CSV_LinksOffers)) {                             
  assign(paste0("data", i),                                 
         read.csv(paste(CSV_LinksOffers[i])))}


for(i in 1:365){
   dfJoined <-left_join(get(paste0('2015data', i)),dfFinalPrice) %>%
    filter(ProductType == 'Energy')%>%
    filter(dfJoined$DollarsPerMegawattHour > 0) %>%
    filter(dfJoined$DollarsPerMegawattHour <= dfJoined$DollarsPerMegawattHourFinal)%>%
    group_by(TradignDate, TradingPeriod, PointOfConnection, PointOfConnectionFinal, DollarsperMegawattHour)%>%
    summarise(MaxOffer = max(DollarsPerMegawattHour))
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