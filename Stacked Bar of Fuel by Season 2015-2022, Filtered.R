#### Comparing Fuel type of Marg generator in different seasons Filtered


pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes, lubridate)

pPathFiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Filtered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')



GeneratorsFuelType <- read_excel('L:\\DuncanFulton\\Marginal-Generation\\Data\\Generators and fuel type.xlsx')

for (yearIndex in c(2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) {
  
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
  filter(!TradingPeriod == 50)

colnames(df) <-  c('TradingDate', 'TradingPeriod', 'GXP', 'DollarsPerMegawattHour', 'ParticipantCode', 'Generator', 'TypeOfFuel', 'CarbonIntensity')

df$season <- if_else(month(df$TradingDate) %in% c(12, 01, 02), "Summer",
                    if_else(month(df$TradingDate) %in% c(03, 04, 05), "Autumn",
                            if_else(month(df$TradingDate) %in% c(06, 07, 08), "Winter", "Spring")))

df$TypeOfFuel <- factor(df$TypeOfFuel, levels = c('Diesel', 'Hydro', 'Gas', 'Gas /coal', 'Geothermal', 'Geothermal/Hydro', 'Wind'))


{p <- ggplot(data = df,
             aes(x =season)) + 
    geom_bar(position = "stack", aes(fill = factor(TypeOfFuel))) + 
    theme_fivethirtyeight() +
    labs(
      x = 'Trading Period',
      y = 'Count', 
      title = 'Generation Counts Per Trading Period',
      fill = 'Form of Generation'
    ) +
    theme(axis.title = element_text()) 
  p
  
  ggsave(paste0(pPathFiltered, 'StackedBarbySeason2015-2022filtered.png'))
}
