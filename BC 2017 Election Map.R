
library(sf)
library(tidyverse)
library(rmapshaper)


#Download shapefile of BC Electoral District Boundaries
temp <- tempfile()
download.file("https://catalogue.data.gov.bc.ca/dataset/9530a41d-6484-41e5-b694-acb76e212a58/resource/34eedf53-c60b-4237-bf6e-81228a51ab12/download/edsre2015.zip",temp)
data <- st_read(unzip(temp)[3])
unlink(temp)

#simplify to make mapping faster
data.sim<-ms_simplify(data)

ggplot(data.sim)+
  geom_sf(fill="white")+
  coord_sf()


#Download past voting results

voting<-read_csv("https://catalogue.data.gov.bc.ca/dataset/44914a35-de9a-4830-ac48-870001ef8935/resource/fb40239e-b718-4a79-b18f-7a62139d9792/download/provincial_voting_results.csv")

#Filter to focus on 2017 and the party affiliation of the elected MLAs
winners_2017<-voting %>%
  filter(EVENT_YEAR==2017 & ELECTED=="Y") %>% #There was a by-elxn in 2018, but the party affiliation of the elected MLA did not change
  select(ED_ABBREV=ED_ABBREVIATION,AFFILIATION) %>%
  distinct()

#Merge with the Electoral District info
 data.sim<-data.sim %>%
   inner_join(winners_2017, by="ED_ABBREV")


 ggplot(data.sim,aes(fill=AFFILIATION))+
   geom_sf()+
   coord_sf()+
   scale_fill_manual(name="",values=c("springgreen3","red", "Orange"))+
   labs(title="British Columbia \n 2017 Election Results")+
   theme(legend.position="bottom")



 ggplot(data.sim,aes(fill=AFFILIATION))+
    geom_sf()+
    coord_sf(xlim=c(-125,-122),ylim=c(48.25,49.75))+
    scale_fill_manual(name="",values=c("springgreen3","red", "Orange"))+
    labs(title="British Columbia: 2017 Election Results:\n Victoria and Vancouver")+
    theme(legend.position="bottom")


