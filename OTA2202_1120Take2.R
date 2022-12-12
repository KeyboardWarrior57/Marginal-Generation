pacman::p_load(readxl, readr, dplyr, data.table)

install.packages('dplyr')
library(dplyr)


dPath <- paste0('L:/DuncanFulton/MarginalGeneration/Data/')



dfFinalPrice <- read_excel(paste0(dPath, '20221120_FinalEnergyPrices.xlsx'))

dfOTA2202FinalPrice <- dfFinalPrice[dfFinalPrice$PointOfConnection ==   "OTA2202",]

colnames(dfOTA2202FinalPrice) <- c("TradingDate", "TradingPeriod", 
                                   "PointOfConnectionOTA2202","DollarsPerMegawattHourOTA2202")

dfOffers1120 <- read_excel(paste0(dPath,"20221120_Offers.xlsx"))
                           
                           
                           
dfOTA2202Joined <- left_join(dfOffers1120, dfOTA2202FinalPrice)

                           
dfOTA2202Marginal <- dfOTA2202Joined[dfOTA2202Joined$DollarsPerMegawattHour <= 
                                                                  dfOTA2202Joined$DollarsPerMegawattHourOTA2202,] 
                        
dfOTA2202Marginal <-  dfOTA2202Marginal[dfOTA2202Marginal$DollarsPerMegawattHour > 0,]

dfOTA2202Marginal$Difference <- (dfOTA2202Marginal$DollarsPerMegawattHourOTA2202 - 
                                                                         dfOTA2202Marginal$DollarsPerMegawattHour)

dfOTA2202Marginal <- dfOTA2202Marginal%>%
  filter(ProductType == 'Energy')
                           
                  

dfMins <- dfOTA2202Marginal%>%
  select(TradingDate:Unit, DollarsPerMegawattHourOTA2202, Difference)%>%
  group_by(TradingPeriod, TradingDate)%>%
  summarise(Difference = min(Difference))


dfOTA2202MarginalGenerator <- left_join(dfMins, dfOTA2202Marginal)

dfOTA2202MarginalGeneratorDistinct <-  dfOTA2202MarginalGenerator%>%
  distinct(TradingPeriod, TradingDate, PointOfConnection)


