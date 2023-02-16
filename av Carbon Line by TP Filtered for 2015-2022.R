### Line Graph of Average Carbon Intensity over a Day Filtered 2015 - 2022

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPathFiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Filtered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')

GeneratorLocation <- read_csv(paste0(dPath, 'GeneratorLocation.csv'))

colnames(GeneratorLocation) <- c('Generator', 'Region', 'Island')

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
    filter(!TradingPeriod == 50) %>%
      na.omit()                    ### Used to take out one KIN obs
  
  colnames(df) <-  c('TradingDate', 'TradingPeriod', 'GXP', 'DollarsPerMegawattHour', 'ParticipantCode', 'Generator', 'TypeOfFuel', 'CarbonIntensity')
  
  dfRegion <- left_join(df, GeneratorLocation) 

  av_carbon_intensityBoth <- dfRegion %>%
    group_by(TradingPeriod) %>%
    summarise(av = mean(CarbonIntensity)) %>% 
    mutate(Island = "New Zealand")
  
  dfNI <- dfRegion %>%
    filter(Island == 'NI - North Island')
  
  av_carbon_intensityNI <- dfNI %>%
    group_by(TradingPeriod) %>%
    summarise(av = mean(CarbonIntensity)) %>%
    mutate(Island = "North Island"  )
  
  av_carbon_intensity <- rbind(av_carbon_intensityBoth, av_carbon_intensityNI)

  myColors <-  c("#5accc6", "#b53f0d")
  
  {p1 <- ggplot(data = av_carbon_intensity, aes(x = TradingPeriod, y = av, color = Island)) +
      geom_line(linewidth = 1.5) +
      labs(title = "Average Carbon Intensity over the of a Day",
           subtitle = "During 2015-2022",
           x = "TradingPeriod",
           y = "Carbon Intensity (kg CO2/KWh)",
           color = "Area") +
      theme_fivethirtyeight() +
      ylim(0, NA) +
        theme(axis.title = element_text()) +
      scale_color_manual(values = myColors)
      p1
      
    ggsave(paste0(pPathFiltered, 'AvCarbonLinebyTP2015-2022filtered.png'))
    }
