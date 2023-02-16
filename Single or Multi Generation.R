
dfSingle <- dfSingleOrMulti %>%
  filter(NumberOfGens == "single")


av_carbon_intensitySingle <- dfSingle %>%
  group_by(TradingPeriod) %>%
  summarise(av = mean(CarbonIntensity))

p <- ggplot(data = av_carbon_intensitySingle,
            aes(x = TradingPeriod, y = av)) +
  geom_line()
p

NorthandSingle <-  filter(dfSingle, Island == "NI - North Island")

p2 <- ggplot(data = NorthandSingle,
             aes(x = TypeOfFuel)) +
  geom_bar()
p2


