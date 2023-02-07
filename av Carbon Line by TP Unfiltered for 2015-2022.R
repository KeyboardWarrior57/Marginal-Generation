### Line Graph of Average Carbon Intensity over a Day Unfiltered 2015-2022

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPathUnfiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Unfiltered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')


GeneratorsFuelType <- read_excel('L:\\DuncanFulton\\Marginal-Generation\\Data\\Generators and fuel type.xlsx')

for (yearIndex in c(2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) {
  
  data_framet <-  read_csv(paste0(dPath, "MarginalGenerator", as.character(yearIndex), ".csv"))
  
  if (yearIndex == 2015) {
    data_frametAll <- data_framet
  }
  else {
    data_frametAll <- rbind(data_frametAll, data_framet)
  }
}

df <- left_join(data_frametAll, GeneratorsFuelType) %>%
  filter(!TradingPeriod == 49) %>%
  filter(!TradingPeriod == 50)

colnames(df) <-  c('TradingDate', 'TradingPeriod', 'GXP', 'DollarsPerMegawattHour', 'ParticipantCode', 'Generator', 'TypeOfFuel', 'CarbonIntensity')


av_carbon_intensity <- df %>%
  group_by(TradingPeriod) %>%
  summarise(av = mean(CarbonIntensity))


{p1 <- ggplot(data = av_carbon_intensity,
              aes(x = TradingPeriod, y = av)) +
    geom_line(aes(), size = 1.5, color = "#5accc6") + 
    labs(title = "Average Carbon Intensity over the of a Day",
         subtitle = "During 2015-2022",
         x = "TradingPeriods",
         y = "Carbon Intensity (kg CO2/KWh)") +
    theme_fivethirtyeight() +
    theme(axis.title = element_text())
  p1
  
  ggsave(paste0(pPathFiltered, 'AvCarbonLinebyTP2015-2022.png'))
  }
