#### Line graph of average carbon intensity daily profile by season 


### Dry year 2020


pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes, lubridate)

pPathFiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Filtered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')

GeneratorLocation <- read_csv(paste0(dPath, 'GeneratorLocation.csv'))

colnames(GeneratorLocation) <- c('Generator', 'Region', 'Island')

GeneratorsFuelType <- read_excel('L:\\DuncanFulton\\Marginal-Generation\\Data\\Generators and fuel type.xlsx')


df <- left_join(read_csv(paste0(dPath, "MarginalGenerator2020_filtered.csv")),GeneratorsFuelType) %>%
  filter(!TradingPeriod == 49) %>%
  filter(!TradingPeriod == 50) %>%
  na.omit()                        ### This is only to exclude the KIN0112 wood plant that appears once in the whole 8 years of data so I don't want it in the ledgend


colnames(df) <-  c('TradingDate', 'TradingPeriod', 'GXP', 'DollarsPerMegawattHour', 'ParticipantCode', 'Generator', 'TypeOfFuel', 'CarbonIntensity')

df$season <- if_else(month(df$TradingDate) %in% c(12, 01, 02), "Summer",
                     if_else(month(df$TradingDate) %in% c(03, 04, 05), "Autumn",
                             if_else(month(df$TradingDate) %in% c(06, 07, 08), "Winter", "Spring")))



dfSummer <-  df %>%
  filter(season == 'Summer')%>%
  group_by(TradingPeriod) %>%
  summarise(av = mean(CarbonIntensity)) %>% 
  mutate(season = 'Summer')

dfAutumn <-  df %>%
  filter(season == 'Autumn')%>%
  group_by(TradingPeriod) %>%
  summarise(av = mean(CarbonIntensity)) %>% 
  mutate(season = 'Autumn')



dfWinter <-  df %>%
  filter(season == 'Winter')%>%
  group_by(TradingPeriod) %>%
  summarise(av = mean(CarbonIntensity)) %>% 
  mutate(season = 'Winter')



dfSpring <-  df %>%
  filter(season == 'Spring')%>%
  group_by(TradingPeriod) %>%
  summarise(av = mean(CarbonIntensity)) %>% 
  mutate(season = 'Spring')


dfSeasonAvIntensity <- rbind(dfAutumn, dfSpring, dfSummer, dfWinter)


p <- ggplot(data = dfSeasonAvIntensity, aes(x = TradingPeriod, y = av, color = season)) +
  geom_line(linewidth = 1.5, alpha = 0.8) +
  labs(title = "Average Carbon Intensity over the of a Day",
       subtitle = "2020",
       x = "TradingPeriod",
       y = "Carbon Intensity (kg CO2/KWh)",
       color = "Season") +
  ylim(0, 0.08) +
  theme(axis.title = element_text()) 

ggsave(paste0(pPathFiltered, 'All Seasons Av Carbon Line by TP 2020 (wet Year) filtered.png'))