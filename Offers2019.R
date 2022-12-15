installed.packages("rvest")

library("rvest")

installed.packages("dplyr")

library("dplyr")


link2019 = 'https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/2019'

page2019 = read_html(link2019)

CSV_LinksOffers2019 <- page2019 %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )

for(i in 236:length(CSV_LinksOffers2019)) {                              
  assign(paste0("2019data", i),                                   
         read.csv(paste(CSV_LinksOffers2019[i])))
}

dataframe_names2019 <-  paste0("2019data", 1:365)
dataframes2019 <- list()
for (name in dataframe_names2019){
  dataframes2019[[name]] <- get(name)
}

df_Offers2019 <- bind_rows(dataframes2019)

readr::write_csv(df_Offers2019, paste0(dPath, 'Offers2019.csv'))


#for(i in 1:365){
 # dftemp <- read.csv(paste0(CSV_LinksOffers2019[i]))
  #if (i == 1){
   # df <- dftemp
  #} else {
   # df <- rbind(df, dftemp)
  #}
#}
#df_Offers2019 <- df