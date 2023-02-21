#### Changing data into that only equal priced generators appear



pacman::p_load(readr, dplyr)

years_of_data <- c('2015', '2016', '2017', '2018', '2019', '2020', '2021')

for (year_index in years_of_data){
  MarginalGenerator <- read_csv(paste0(dPath,"MarginalGenerator", year_index, ".csv"))
  MarginalGenFiltered <- MarginalGenerator %>% filter(Generator == GXP)
  write_csv(MarginalGenFiltered, paste0(dPath, "MarginalGenerator", year_index, "_filtered.csv"))
}