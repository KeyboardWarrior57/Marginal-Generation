dfOffers <- data.frame(X20221112_Offers)
dfOffers
#OffersCleared <- dfOffers = dfOffers with MW not equal to zero
install.packages('dplyr')
library(dplyr)
#OffersCleared <- filter[dfOffers$Megawatts != 0]
#OffersCleared <- apply(dfOffers,1, filter[dfOffers$Megawatts != 0])
filter(dfOffers, Megawatts > 0)
dfClearedOffers <- filter(dfOffers, Megawatts > 0)
#Find max DollarsPerMegawattHour for each trading period
Marg1 <- apply(dfClearedOffers, c(1, TradingPeriod == 1), which.max(dfClearedOffers$DollarsPerMegawattHour))  

