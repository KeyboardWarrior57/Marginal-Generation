#### This counts the number of marginal generators for each trading period,
# joins it with other data, and saves as FullMarginalGensWithNumbers.csv

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes, lubridate)

pPath <- paste0(here::here(), "/Plots/")
dPath <- paste0(here::here(), "/Data/")

GeneratorLocation <- read_csv(paste0(dPath, 'GeneratorLocation.csv'))

colnames(GeneratorLocation) <- c('Generator', 'Region', 'Island')

GeneratorsFuelType <- read_excel(paste0(dPath, 'GeneratorsAndFuelType.xlsx'))

for (yearIndex in c(2015, 2016, 2017, 2018, 2019, 2020, 2021)) {
  
  data_framet <-  read_csv(paste0(dPath, "MarginalGenerator", as.character(yearIndex), "_filtered.csv"))
  
  if (yearIndex == 2015) {
    data_frametAll <- data_framet
  }
  else {
    data_frametAll <- rbind(data_frametAll, data_framet)
  }
}

df <- left_join(data_frametAll, GeneratorsFuelType) %>%
  filter(!TradingPeriod == 49) %>%
  filter(!TradingPeriod == 50) %>%
  na.omit()                        ### This is only to exclude the KIN0112 wood plant that appears once in the whole 8 years of data so I don't want it in the ledgend

colnames(df) <-  c('TradingDate', 'TradingPeriod', 'GXP', 'DollarsPerMegawattHour', 'ParticipantCode', 'Generator', 'TypeOfFuel', 'CarbonIntensity')

df$season <- if_else(month(df$TradingDate) %in% c(12, 01, 02), "Summer",
                     if_else(month(df$TradingDate) %in% c(03, 04, 05), "Autumn",
                             if_else(month(df$TradingDate) %in% c(06, 07, 08), "Winter", "Spring")))

dfRegion <- left_join(df, GeneratorLocation)

dfGrouped <- dfRegion %>% 
  group_by(TradingDate, TradingPeriod) %>%
  summarise(NumberOfGens = n())

dfGrouped$SingleOrMultiple <- if_else(dfGrouped$NumberOfGens == 1, "Single", "Multiple")

dfNumberOfGens<- left_join(dfRegion, dfGrouped)

write_csv(dfNumberOfGens, paste0(dPath, 'FullMarginalGensWithNumbers.csv'))


