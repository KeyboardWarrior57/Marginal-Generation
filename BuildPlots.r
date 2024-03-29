#### This script builds the plots from preprocessed data

#### Line Graph of Carbon intensity by each TP for all seasons
# supersedes All seasons on one graph av carbon line.R

pacman::p_load(readr, dplyr, readxl, ggplot2, ggthemes, lubridate)

pPath <- paste0(here::here(), "/Plots/")
dPath <- paste0(here::here(), "/Data/")

# Load data
GeneratorLocation <- read_csv(paste0(dPath, "GeneratorLocation.csv"))
colnames(GeneratorLocation) <- c("Generator", "Region", "Island")
GeneratorsFuelType <- read_excel(paste0(dPath, "GeneratorsAndFuelType.xlsx"))
VectorColours <- read_csv("C:/Users/ParkerR/Data/VectorColours.csv")

myColors <- VectorColours$hex

# Load functions
source('carbonIntensityBySeason.R')
source('addSeasons.R')

# Process data
# years 2015 to 2021 (2022 needs reprocessing to include ParticipantCode column)
years <- c(2015, 2016, 2017, 2018, 2019, 2020, 2021)
for (yearIndex in years) {
  print(yearIndex)
  data_framet <- read_csv(paste0(dPath, "MarginalGenerator", as.character(yearIndex), "_filtered.csv"))
  data_framet$Year <- yearIndex
  if (yearIndex == 2015) {
    data_frametAll <- data_framet
  } else {
    data_frametAll <- rbind(data_frametAll, data_framet)
  }
}

df_full <- left_join(data_frametAll, GeneratorsFuelType) %>%
  filter(!TradingPeriod == 49) %>%
  filter(!TradingPeriod == 50) %>%
  na.omit() ### This is only to exclude the KIN0112 wood plant that appears once in the whole 8 years of data so I don't want it in the ledgend

colnames(df_full) <- c("TradingDate", "TradingPeriod", "GXP", "DollarsPerMegawattHour", 
                       "ParticipantCode", "Generator", "Year", "TypeOfFuel", "CarbonIntensity")

df_full <- addSeasons(df_full)
dfSeasonAvIntensity <- SeasonAvIntensity(df_full)

# Plot
# create the plot with specified colors
p0 <- ggplot(data = dfSeasonAvIntensity, aes(x = TradingPeriod, y = av, color = Season)) +
  geom_line(linewidth = 1.5, alpha = 0.8) +
  scale_color_manual(values = myColors) +  # specify the colors
  labs(
    title = "Daily Profile of Marginal Generator Carbon Intensity",
    subtitle = "2015-2022",
    x = "Trading Period",
    y = "Carbon Intensity (kg CO2/kWh)",
    color = "Season"
  ) +
  ylim(0, 0.08) +
  theme(axis.title = element_text()) 

# save the plot
ggsave(paste0(pPath, "AllSeasonsDailyProfileCarbonIntensity2015-2022.png"),
       plot = p0, width = 10, height = 6, dpi = 300
)


#### Line graph of average carbon intensity daily profile by season for each year
# This supersedes the scripts 'All_seasons Av line 2019 (ref year)/2020 (wet year).r'
# and 'All seasons stacked bar 2019 (Ref year)/2020 (dry).r'

dfRegion <- left_join(df_full, GeneratorLocation) %>%
  addSeasons()
dfRegion$TypeOfFuel <- factor(
  dfRegion$TypeOfFuel,
  levels = c(
    "Hydro",
    "Wind",
    "Geothermal/Hydro (WKM 2201)",
    "Geothermal",
    "Gas",
    "Gas/Coal (HLY2201)",
    "Diesel"
  )
)


# Plot data by year
for (year in years) {
  # Filter
  df <- df_full[df_full$Year == year, ] 
  dfSeasonAvIntensity <- SeasonAvIntensity(df)
  # Plot
  p1 <- ggplot(data = dfSeasonAvIntensity, aes(x = TradingPeriod, y = av, color = Season)) +
    geom_line(linewidth = 1.5, alpha = 0.8) +
    labs(
      title = "Daily Profile of Marginal Generator Carbon Intensity",
      subtitle = year,
      x = "Trading Period",
      y = "Carbon Intensity (kg CO2/kWh)",
      color = "Season"
    ) +
    ylim(0, 0.08) +
    scale_color_manual(values = myColors) +
    theme(axis.title = element_text())

  ggsave(paste0(pPath, "AllSeasonsAvCarbonProfile", as.character(year), ".png"),
    plot = p1, width = 10, height = 6, dpi = 300
  )
  p2 <- ggplot(data = df,
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
  
  ggsave(paste0(pPath, 'StackedBarbyTP', year,'.png'), plot = p2)
  
  p3 <- ggplot(data = df,
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
  
  ggsave(paste0(pPath, 'StackedBarbyTP', year, 'filtered.png'), plot = p3)
}

  for (seasonIndex in c("Summer", "Autumn", "Winter", "Spring")) {
    dfSeason <- dfRegion %>%
      addSeasons() %>%
      filter(Season == seasonIndex)

    p2 <- ggplot(
      data = dfSeason,
      aes(x = TradingPeriod)
    ) +
      geom_bar(position = "fill", aes(fill = factor(TypeOfFuel))) +
      theme_fivethirtyeight() +
      labs(
        x = "Trading Period",
        y = "Ratio",
        title = "Generation per Trading Period",
        subtitle = as.character(seasonIndex),
        fill = "Generation Type"
      ) +
      theme(axis.title = element_text())


    ggsave(paste0(pPath, "StackedBarbyTP", seasonIndex, ".png"),
      plot = p2, width = 10, height = 6, dpi = 300)
  
}


### Line Graph of Average Carbon Intensity over a Day by Island
# (supersedes av Carbon Line by TP filtered for 2015-2022)

av_carbon_intensityBoth <- dfRegion %>%
  group_by(TradingPeriod) %>%
  summarise(av = mean(CarbonIntensity)) %>%
  mutate(Island = "New Zealand")

dfNI <- dfRegion %>%
  filter(Island == "NI - North Island")

av_carbon_intensityNI <- dfNI %>%
  group_by(TradingPeriod) %>%
  summarise(av = mean(CarbonIntensity)) %>%
  mutate(Island = "North Island")

av_carbon_intensity <- rbind(av_carbon_intensityBoth, av_carbon_intensityNI)

p1 <-
  ggplot(data = av_carbon_intensity, aes(x = TradingPeriod, y = av, color = Island)) +
  geom_line(linewidth = 1.5) +
  labs(
    title = "Average Carbon Intensity over the of a Day",
    subtitle = "During 2015-2022",
    x = "TradingPeriod",
    y = "Carbon Intensity (kg CO2/KWh)",
    color = "Area"
  ) +
  theme_fivethirtyeight() +
  ylim(0, NA) +
  theme(axis.title = element_text()) +
  scale_color_manual(values = myColors)
p1

ggsave(paste0(pPath, "AvCarbonLinebyTP2015-2022filtered.png"))


# All seasons stacked bar 2019 (Ref) and 2020 (Dry)
seasons <- unique(df$Season)
for (year in years) {
  dftmp <- df_full[df_full$Year == year, ]
  for (season in seasons) {
    p <- ggplot(data = dftmp[dftmp$Season == season,],
                aes(x = TradingPeriod)) +
      geom_bar(position = "fill", aes(fill = factor(TypeOfFuel))) +
      theme_fivethirtyeight() +
      labs(
        x = 'Trading Period',
        y = 'Ratio',
        title = paste0('Generation Per Trading Period (', season, ' ', as.character(year), ')'),
        fill = 'Generation Type'
      ) +
      theme(axis.title = element_text())
    p
    ggsave(paste0(pPath, 'stackedbars/', season, year, '.png'), height = 6, width = 7.5)
  }
}

# Stacked Bar Of Fuel By Season 2105-2022
p <- ggplot(data = df_full,
            aes(x = Season)) + 
  geom_bar(position = "stack", aes(fill = factor(TypeOfFuel))) + 
  theme_fivethirtyeight() +
  labs(
    x = 'Trading Period',
    y = 'Count', 
    title = 'Generation Counts Per Trading Period',
    fill = 'Form of Generation'
  ) +
  theme(axis.title = element_text()) 
p

ggsave(paste0(pPathFiltered, 'StackedBarbySeason2015-2022filtered.png'))


