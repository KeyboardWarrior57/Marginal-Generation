installed.packages("rvest")

library("rvest")

installed.packages("dplyr")

library("dplyr")


link = 'https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/2019'

page = read_html(link)

CSV_LinksOffers2019 <- page %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


for(i in 1:365){
  dftemp <- read.csv(paste0(CSV_Links[i]))
  if (i == 1){
    df <- dftemp
  } else {
    df <- rbind(df, dftemp)
  }
}
df_Offers2019 <- df