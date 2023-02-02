### Stacked Bar chart of gen fuels by TP for all years Unfiltered


pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPathUnfiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Unfiltered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')


GeneratorsFuelType <- read_excel('L:\\DuncanFulton\\Marginal-Generation\\Data\\Generators and fuel type.xlsx')

for (yearIndex in c(2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022)) {
  
assign(paste0("MarginalGenerator", as.character(yearIndex)), read_csv(paste0(dPath, "MarginalGenerator", as.character(yearIndex), ".csv")))
  
  df <- left_join(paste0("MarginalGenerator", yearIndex), GeneratorsFuelType) %>%
    filter(!TradingPeriod == 49) %>%
    filter(!TradingPeriod == 50)

  colnames(df) <-  c('TradingDate', 'TradingPeriod', 'GXP', 'DollarsPerMegawattHour', 'ParticipantCode', 'Generator', 'TypeOfFuel', 'CarbonIntensity')
  
  df$TypeOfFuel <- factor(df$TypeOfFuel, levels = c('Diesel', 'Hydro', 'Gas', 'Gas /coal', 'Geothermal', 'Geothermal/Hydro', 'Wind'))
  
  
  {p <- ggplot(data = df,
               aes(x =TradingPeriod)) + 
      geom_bar(position = "stack", aes(fill = factor(TypeOfFuel))) + 
      theme_fivethirtyeight() +
      labs(
        x = 'Trading Period',
        y = 'Count', 
        title = 'Generation Counts Per Trading Period',
        fill = 'Form of Generation'
      ) +
      theme(axis.title = element_text()) 
    
    ggsave(paste0(pPathUnfiltered, 'StackedBarbyTP', as.character(yearIndex), '.png'))
  }
}