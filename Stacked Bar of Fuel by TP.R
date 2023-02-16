#### Stacked bar graph of generation type by TP

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPathUnfiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Unfiltered\\' 


GeneratorsFuelType <- read_excel('L:\\DuncanFulton\\Marginal-Generation\\Data\\Generators and fuel type.xlsx')


MarginalGeneratorOTA2201_2019 <- read.csv("L:\\DuncanFulton\\Marginal-Generation\\Data\\MarginalGeneratorOTA2201_2019.csv")

df <- left_join(MarginalGeneratorOTA2201_2019, GeneratorsFuelType) %>%
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

ggsave(paste0(pPathUnfiltered, 'StackedBarbyTP', '2019', '.png'))
}