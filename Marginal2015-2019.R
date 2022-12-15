## 2015 - 2019, (pre-Covid) all GXPs and TPs Marginal Generators, can pulkl individual GXPs from 

pacman::p_load(readxl, readr, dplyr, data.table)


FinalPricing2015 <- read.csv(paste0(dPath, 'FinalPricing2015.csv'))
FinalPricing2016 <- read.csv(paste0(dPath, 'FinalPricing2016.csv'))
FinalPricing2017 <- read.csv(paste0(dPath, 'FinalPricing2017.csv'))
FinalPricing2018 <- read.csv(paste0(dPath, 'FinalPricing2018.csv'))
FinalPricing2019 <- read.csv(paste0(dPath, 'FinalPricing2019.csv'))
                             
FinalPricingPreCovid <-  rbind(FinalPricing2015, FinalPricing2016, FinalPricing2017, FinalPricing2018, FinalPricing2019)

colnames(FinalPricingPreCovid) <- c( "TradingDate", "TradingPeriod", 
                                    "PointOfConnectionFinal","DollarsPerMegawattHourFinal")

Offers2015 <- read.csv(paste0(dPath, 'Offers2015.csv'))
Offers2016 <- read.csv(paste0(dPath, 'Offers2016.csv'))
Offers2017 <- read.csv(paste0(dPath, 'Offers2017.csv'))
Offers2018 <- read.csv(paste0(dPath, 'Offers2018.csv'))            
Offers2019 <- read.csv(paste0(dPath, 'Offers2019.csv'))
                       
OffersPreCovid <- rbind(Offers2015, Offers2016, Offers2017, Offers2018, Offers2019)

OffersPreCovidTrimmed <-  OffersPreCovid %>% 
  OffersPreCovid[OffersPreCovid$DollarsPerMegawattHour > 0] %>%
  filter(ProductType == 'Energy')

dfJoined <- left_join(OffersPreCovidTrimmed, FinalPricingPreCovid)

dfJoined <- dfJoined[dfJoined$DollarsPerMegawattHour <= dfJoined$DollarsPerMegawattHourFinal]



dfMarginal <- dfJoined %>%
  group_by(TradingDate,TradingPeriod, PointOfConnection, pointofConnectionFinal) %>%
  summarise(MaxOffer = max(DollarsPerMegawattHour))