# source:
# http://www.worldometers.info/world-population/population-by-country/

path.output = '../data'
file.data = file.path(path.output, 'World Data Population.csv')
data = read.csv(file.data, header=FALSE, stringsAsFactors = FALSE)

num.countries = nrow(data)/3 - 1
seq = 1:num.countries

country.names = data[seq*3-1,1]
head(country.names)

country.data = data[seq*3,]
names(country.data) = c('Population (2014)','1 Year Change (%)','Population Change','Migrants (net)',
                        'Median Age','Aged 60+','Fertility Rate','Area (km2)','Density (p/km2)',
                        'Urban Pop (%)','Urban Population','Share of World Population')

d = cbind(Country = country.names, country.data)
as.numeric(gsub(',','',d[,2]))->d[,2]
as.numeric(gsub('%','',d[,3]))->d[,3]
as.numeric(gsub(',','',d[,4]))->d[,4]
as.numeric(gsub(',','',d[,5]))->d[,5]
as.numeric(gsub(',','',d[,9]))->d[,9]
as.numeric(gsub(',','',d[,10]))->d[,10]
as.numeric(gsub(',','',d[,12]))->d[,12]

as.numeric(gsub('%','',d[,7]))->d[,7]
as.numeric(gsub('%','',d[,11]))->d[,11]
as.numeric(gsub('%','',d[,13]))->d[,13]

## save data
write.csv(d, file='world-population.csv')