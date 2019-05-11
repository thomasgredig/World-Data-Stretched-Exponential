# download data and save world's countries areas and population:
# retrieves data from website and saves in file

library(rvest)
source('config.R')

source.url = 'https://www.worldometers.info/world-population/population-by-country/'

df <- as.data.frame(read_html(source.url) %>% html_table(fill=TRUE))

head(df)
str(df)

d = data.frame(
  country.name = df$Country..or.dependency.,
  population = as.numeric(gsub(',','',df$Population..2019.)),
  area = as.numeric(gsub(',','',df$Land.Area..Km..)),
  fertility = as.numeric(df$Fert..Rate),
  urban = as.numeric(gsub('%','', df$Urban.Pop..)),
  migrants = as.numeric(gsub(',','',df$Migrants..net.))
)

write.csv(d, file.path(path.output, FILE.data.world))