### Making Location file of Generators

dPath <- ('L:/DuncanFulton/Marginal-Generation/Data/')

pacman::p_load(readr, dplyr, readxl)

df <- read_csv(paste0(dPath, 'ExistingGenerators.csv'))


GeneratorLocation <-df %>%
  select(Node_Name, Region_Name, Island_Name) %>%
  distinct()

write_csv(GeneratorLocation,
          paste0(dPath, 'GeneratorLocation.csv'))