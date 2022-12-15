installed.packages("rvest")

library("rvest")

installed.packages("dplyr")

library("dplyr")


link2018 = "https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/2018"

page2018 = read_html(link2018)

CSV_LinksOffers2018 <- page2018 %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


for(i in 238:length(CSV_LinksOffers2018)) {                             
    assign(paste0("2018data", i),                                 
            read.csv(paste(CSV_LinksOffers2018[i])))
}




dataframe_names <-  paste0("2018data", 1:365)
dataframes <- list()
for (name in dataframe_names){
  dataframes[[name]] <- get(name)
}

df_Offers2018 <- bind_rows(dataframes)

write.csv(df_Offers2018, "L:/DuncanFulton/Marginal-Generation/Data/Offers2018.csv")
