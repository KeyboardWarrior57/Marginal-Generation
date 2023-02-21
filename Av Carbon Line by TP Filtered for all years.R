### Line Graph of Average Carbon Intensity over a Day Filtered

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPathFiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Filtered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')


GeneratorsFuelType <- read_excel('L:\\DuncanFulton\\Marginal-Generation\\Data\\Generators and fuel type.xlsx')

for (yearIndex in c(2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) {
  
  data_framet <-  read_csv(paste0(dPath, "MarginalGenerator", as.character(yearIndex), "_filtered.csv"))
  
  df <- left_join(data_framet, GeneratorsFuelType) %>%
    filter(!TradingPeriod == 49) %>%
    filter(!TradingPeriod == 50)
  
  colnames(df) <-  c('TradingDate', 'TradingPeriod', 'GXP', 'DollarsPerMegawattHour', 'ParticipantCode', 'Generator', 'TypeOfFuel', 'CarbonIntensity')
  
  
  av_carbon_intensity <- df %>%
    group_by(TradingPeriod) %>%
    na.omit() %>%                                      ## Trading Period in 2020 this method couldn't pick up a marg gen for so ruined graphs
    summarise(av = mean(CarbonIntensity))
  
  
  {p <- ggplot(data = av_carbon_intensity,
               aes(x = TradingPeriod, y = av)) +
      geom_line(aes(), size = 1.5, color = "#5accc6") + 
      labs(title = "Average Carbon Intensity over the of a Day",
           subtitle = as.character(yearIndex),
           x = "TradingPeriods",
           y = "Carbon Intensity (kg CO2/KWh)") +
      theme_fivethirtyeight() +
      ylim(0, 0.06) +
      theme(axis.title = element_text())
    p
    
    ggsave(paste0(pPathFiltered, 'AvCarbonLinebyTP', as.character(yearIndex), 'filtered.png'))
    }
}