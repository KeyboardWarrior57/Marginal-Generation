#### Counts of Renewable vs fossil fuels in Marginal Generator Groupings


pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPathFiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Filtered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')

dfNumberOfGens = read_csv(paste0(dPath, 'FullMarginalGensWithNumbers.csv'))

dfNumberOfGens$Renewable <- if_else(dfNumberOfGens$TypeOfFuel == 'Hydro', "Renewable",
                                       if_else(dfNumberOfGens$TypeOfFuel == 'Wind', "Renewable",
                                               if_else(dfNumberOfGens$TypeOfFuel == 'Geothermal', "Renewable",
                                                       if_else(dfNumberOfGens$TypeOfFuel == 'Geothermal/Hydro (WKM 2201)', "Renewable", "Fossil Fuel"))))

p <- ggplot(data = dfNumberOfGens,
            aes(x = NumberOfGens)) +
  geom_bar(aes(fill = factor(Renewable))) +
  labs(
    x = 'Number of Marginal Generators',
    y = 'Count', 
    title = 'Distrubution of Different Amounts of Margianl Generators',
    subtitle = 'With Fuel Type',
    fill = 'Type of Generation'
  ) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) 

ggsave(paste0(pPathFiltered, 'Number of Marginal Generators and Fuel Type filtered.png'))

