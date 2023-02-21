#### stacked bar for all seasons by TP reference year

### 2019

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes, lubridate)

pPathFiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Filtered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')

GeneratorLocation <- read_csv(paste0(dPath, 'GeneratorLocation.csv'))

colnames(GeneratorLocation) <- c('Generator', 'Region', 'Island')

GeneratorsFuelType <- read_excel('L:\\DuncanFulton\\Marginal-Generation\\Data\\Generators and fuel type.xlsx')


df <- left_join((read_csv(paste0(dPath, "MarginalGenerator2019_filtered.csv"))), GeneratorsFuelType) %>%
  filter(!TradingPeriod == 49) %>%
  filter(!TradingPeriod == 50) %>%
  na.omit()                        ### This is only to exclude the KIN0112 wood plant that appears once in the whole 8 years of data so I don't want it in the ledgend


colnames(df) <-  c('TradingDate', 'TradingPeriod', 'GXP', 'DollarsPerMegawattHour', 'ParticipantCode', 'Generator', 'TypeOfFuel', 'CarbonIntensity')

df$season <- if_else(month(df$TradingDate) %in% c(12, 01, 02), "Summer",
                     if_else(month(df$TradingDate) %in% c(03, 04, 05), "Autumn",
                             if_else(month(df$TradingDate) %in% c(06, 07, 08), "Winter", "Spring")))

dfRegion <- left_join(df, GeneratorLocation)


for (seasonIndex in c("Summer", "Autumn", "Winter", "Spring")){ 
  
  
  dfSeason <- paste0(df, as.character(seasonIndex))
  
  
  dfSeason= dfRegion %>%
    filter(season == as.character(seasonIndex))
  
  dfSeason$TypeOfFuel <- factor(dfSeason$TypeOfFuel, levels = c('Hydro', 'Wind', 'Geothermal/Hydro (WKM 2201)', 'Geothermal',  'Gas', 'Gas/Coal (HLY2201)', 'Diesel'))
  
  
  p<-ggplot(data = dfSeason,
            aes(x =TradingPeriod)) + 
    geom_bar(position = "fill", aes(fill = factor(TypeOfFuel))) + 
    theme_fivethirtyeight() +
    labs(
      x = 'Trading Period',
      y = 'Ratio', 
      title = 'Generation Per Trading Period In 2019, (Reference)',
      subtitle = as.character(seasonIndex),
      fill = 'Generation Type'
    ) +
    theme(axis.title = element_text()) 
  
  
  ggsave(paste0(pPathFiltered, 'StackedBarbyTP', seasonIndex, '2019 reference year.png'))
  
}