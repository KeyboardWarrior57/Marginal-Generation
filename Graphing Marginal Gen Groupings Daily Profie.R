####    Number Of Marginal Gens by each Trading Period

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPathFiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Filtered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')

dfNumberOfGens = read_csv(paste0(dPath, 'FullMarginalGensWithNumbers.csv'))


p <- ggplot(data = dfNumberOfGens,
            aes(x = TradingPeriod, y = NumberOfGens)) +
  geom_boxplot(aes(group = TradingPeriod)) +
  labs(
    x = 'Trading Period',
    y = 'Number of Marginal Generators Groupings',
    title = 'Marginal Generator Groupings Daily Profile'
  ) + theme_fivethirtyeight() +
  theme(axis.title = element_text()) 

ggsave(paste0(pPathFiltered, 'Marginal Generator Groupings Daily Profile filtered.png'))