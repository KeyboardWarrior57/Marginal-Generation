#### Count of different numbers of marginal generators and what island they are coming from


pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes)

pPathFiltered <- 'L:\\DuncanFulton\\Marginal-Generation\\Plots\\Filtered\\' 

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')

dfNumberOfGens = read_csv(paste0(dPath, 'FullMarginalGensWithNumbers.csv'))

p <- ggplot(data = dfNumberOfGens,
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