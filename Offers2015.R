link2015 = "https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/2015"

page2015  = read_html(link2015)

CSV_LinksOffers2015 <- page2015 %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


for(i in 1:length(CSV_LinksOffers2015)) {                             
  assign(paste0("2015data", i),                                 
         read.csv(paste(CSV_LinksOffers2015[i])))
}




dataframe_names2015 <-  paste0("2015data", 1:365)
dataframes2015 <- list()
for (name in dataframe_names2015){
  dataframes2015[[name]] <- get(name)
}

df_Offers2015 <- bind_rows(dataframes2015)

readr::write_csv(df_Offers2015, paste0(dPath, 'Offers2015.csv'))
