link2016 = "https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/2016"

page2016  = read_html(link2016)

CSV_LinksOffers2016 <- page2016 %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


for(i in 129:length(CSV_LinksOffers2016)) {                             
  assign(paste0("2017data", i),                                 
         read.csv(paste(CSV_LinksOffers2016[i])))
}




dataframe_names2016 <-  paste0("2017data", 1:366)
dataframes2016 <- list()
for (name in dataframe_names2016){
  dataframes2016[[name]] <- get(name)
}

df_Offers2016 <- bind_rows(dataframes2016)

readr::write_csv(df_Offers2016, paste0(dPath, 'Offers2016.csv'))
