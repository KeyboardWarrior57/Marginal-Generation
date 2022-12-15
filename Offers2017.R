
link2017 = "https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/2017"

page2017 = read_html(link2017)

CSV_LinksOffers2017 <- page2017 %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )


for(i in 338:length(CSV_LinksOffers2017)) {                             
  assign(paste0("2017data", i),                                 
         read.csv(paste(CSV_LinksOffers2017[i])))
}




dataframe_names2017 <-  paste0("2017data", 1:365)
dataframes2017 <- list()
for (name in dataframe_names2017){
  dataframes2017[[name]] <- get(name)
}

df_Offers2017 <- bind_rows(dataframes2017)

readr::write_csv(df_Offers2017, paste0(dPath, 'Offers2017.csv'))
