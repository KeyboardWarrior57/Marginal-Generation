# This script counts marginal generators and what island they are coming from
# Need to run CreateNumberofGensDataframe.R first

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPath <- paste0(here::here(), "/Plots/")
dPath <- paste0(here::here(), "/Data/")

dfNumberOfGens = read_csv(paste0(dPath, 'FullMarginalGensWithNumbers.csv'))

p0 <- ggplot(data = dfNumberOfGens,
            aes(x = NumberOfGens)) +
  geom_bar(aes(fill = factor(Island))) +
  labs(
    x = 'Number of Marginal Generators',
    y = 'Count', 
    title = 'Distrubution of Different Amounts of Margianl Generators',
    subtitle = 'With Location',
    fill = 'Island'
  ) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) 

ggsave(paste0(pPathFiltered, 'Number of Marginal Generators and Island filtered.png'))


dfNumberOfGens$Renewable <- if_else(dfNumberOfGens$TypeOfFuel == 'Hydro', "Renewable",
                                    if_else(dfNumberOfGens$TypeOfFuel == 'Wind', "Renewable",
                                            if_else(dfNumberOfGens$TypeOfFuel == 'Geothermal', "Renewable",
                                                    if_else(dfNumberOfGens$TypeOfFuel == 'Geothermal/Hydro (WKM 2201)', "Renewable", "Fossil Fuel"))))

p1 <- ggplot(data = dfNumberOfGens,
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

ggsave(paste0(pPath, 'Number of Marginal Generators and Fuel Type filtered.png'))

p2 <- ggplot(data = dfNumberOfGens,
            aes(x = TradingPeriod, y = NumberOfGens)) +
  geom_boxplot(aes(group = TradingPeriod)) +
  labs(
    x = 'Trading Period',
    y = 'Number of Marginal Generators Groupings',
    title = 'Marginal Generator Groupings Daily Profile'
  ) + theme_fivethirtyeight() +
  theme(axis.title = element_text()) 

ggsave(paste0(pPathFiltered, 'Marginal Generator Groupings Daily Profile filtered.png'))
