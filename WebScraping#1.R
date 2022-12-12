installed.packages("rvest")

library("rvest")

installed.packages("dplyr")

library("dplyr")


link = "https://www.emi.ea.govt.nz/Wholesale/Datasets/BidsAndOffers/Offers/2022"

page = read_html(link)


CSV_LinksOffers2022 <- page %>% 
  html_nodes(".csv a") %>% 
  html_attr("href") %>% 
  paste("https://www.emi.ea.govt.nz",  ., sep="" )




> for(i in 1:length(CSV_Links)){
  +   dftemp <- read.csv(paste0(CSV_Links[i]))
  +   if (i == 1){
    +     df <- dftemp
    +   } else {
      +     df <- rbind(df, dftemp)
      +   }
  + }


for(i in 1:300){
  dftemp <- read.csv(paste0(CSV_Links[i]))
  if (i == 1){
    df <- dftemp
  } else {
    df <- rbind(df, dftemp)
  }
}
df_Offers2022 <- df



#for(i in 1:length(CSV_Links)) {                              # Head of for-loop
# assign(paste0("data", i),                                   # Read and store data frames
#         read.csv2(paste0(CSV_Links[i])))
}


#for (i in list_of_csv_2022$Name) {
dftemp <- read_csv(paste0(url_2022, i))
if (i == list_of_csv_2022$Name[1]){
  df <- dftemp
} else {
  df <- rbind(df, dftemp)
}
}



#DataSheets <- function(CSV_Links){
# YearData = read.csv() %>% paste(collapse = ",")
#return(YearData)
}
#MetaData = sapply(CSV_Links, FUN = DataSheets)


write_csv(df_Offers2022, "L:/DuncanFulton/Marginal-Generation/Data/Offers2022.csv")
