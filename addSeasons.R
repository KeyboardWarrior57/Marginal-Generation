# This function adds seasons to data based on date
addSeasons <- function(df){
  df$Season <- if_else(month(df$TradingDate) %in% c(12, 01, 02), "Summer",
                       if_else(month(df$TradingDate) %in% c(03, 04, 05), "Autumn",
                               if_else(month(df$TradingDate) %in% c(06, 07, 08), "Winter", "Spring")
                       )
  )
  return(df)
}