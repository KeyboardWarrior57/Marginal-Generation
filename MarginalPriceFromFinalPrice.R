pacman::p_load(readxl, readr, dplyr, data.table)

dPath <- paste0(getwd(), '/Data/')

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

colnames(dfFinalPrice) <- c("TradingDate","TradingPeriod", "PointOfConnection","DollarsPerMegawattHourFinal")

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