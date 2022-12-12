pacman::p_load(readxl, readr, dplyr, data.table)

install.packages('dplyr')
library(dplyr)


dPath <- paste0('L:/DuncanFulton/MarginalGeneration/Data/')



dfFinalPrice <- read_excel(paste0(dPath, '20221120_FinalEnergyPrices.xlsx'))
colnames(dfFinalPrice) <- c("TradingDate", "TradingPeriod", 
                                   "PointOfConnectionFinal","DollarsPerMegawattHourFinal")
  


dfOffers1120 <- read_excel(paste0(dPath,"20221120_Offers.xlsx"))



dfJoined <- left_join(dfOffers1120, dfFinalPrice)


dfMarginal <- dfJoined[dfJoined$DollarsPerMegawattHour <= 
                                       dfJoined$DollarsPerMegawattHourFinal,] 

dfMarginalAbove0 <-  dfMarginal[dfMarginal$DollarsPerMegawattHour > 0,]

dfMarginalAbove0$Difference <- (dfMarginalAbove0$DollarsPerMegawattHourFinal - 
                                   dfMarginalAbove0$DollarsPerMegawattHour)

dfMarginalEnergy <- dfMarginalAbove0%>%
  filter(ProductType == 'Energy')



dfMinsAll <- dfMarginalEnergy%>%
  select(TradingDate:Unit, DollarsPerMegawattHourFinal, PointOfConnectionFinal, Difference)%>%
  group_by(TradingPeriod, TradingDate, PointOfConnectionFinal )%>%
  summarise(Difference = min(Difference))


dfMarginalGenerators <- left_join(dfMinsAll, dfMarginalEnergy)

dfMarginalGeneratorsDistinct <-  dfMarginalGenerators%>%
  distinct(TradingPeriod, TradingDate, PointOfConnectionFinal, PointOfConnection)

dfCount <- dfMarginalGeneratorsDistinct%>%
  count(PointOfConnection)%>%
  arrange(desc(n))