# fit stretched exponential function to areas of countries
source('R/config.R')
library(ggplot2)

# load data
d = read.csv(file.path(path.output, FILE.data.world), 
             stringsAsFactors = FALSE)

# rank by area
d$rank.area[order(d$area, decreasing=TRUE)] = 1:nrow(d)

# plot data
ggplot(d, aes(rank.area, area)) +
  geom_point(col='red') + 
  scale_y_log10() + 
  theme_bw()

# model with  exponential function
nls(data = subset(d, rank.area>10 & rank.area<0.8*max(d$rank.area)),
    area ~ A*exp(-rank.area/tau),
    start = list(A = 1E6, tau = 20)) -> fit
summary(fit)

d$area.predicted = predict(fit, list(rank.area = d$rank.area))
# add exponential fit to the plot
ggplot(d, aes(rank.area, area)) +
  geom_point(col='red') + 
  geom_path(aes(y=area.predicted), col='blue') + 
  scale_y_log10() + 
  theme_bw()

# model with stretched exponential function
nls(data = subset(d, rank.area>10 & rank.area<0.8*max(d$rank.area)),
    area ~ A*exp(-(rank.area/tau)^h),
    start = list(A = 3E6, tau = 28, h=1)) -> fit
summary(fit)

# label the y-axis with powers of 10
scientific_10 <- function(x) {
  parse(text=gsub("e", " %*% 10^", scales::scientific_format()(x)))
}

# make some labels for countries
d$cname = ""
c.list = c(grep("France",d$country.name), grep("Switzerland",d$country.name),
            grep("Brazil",d$country.name), grep("Austria",d$country.name),
           grep("Swazila",d$country.name), grep("Haiti",d$country.name),
           grep("Qat",d$country.name),grep("Nigeri",d$country.name))
d$cname[c.list] = d$country.name[c.list]


d$area.predicted.sexp = predict(fit, list(rank.area = d$rank.area))
# add exponential fit to the plot
ggplot(subset(d, area>1000), 
       aes(rank.area, area, label=cname)) +
  geom_point(col='red', size=1.5) + 
  geom_line(aes(y=area.predicted), col='blue') + 
  geom_line(aes(y=area.predicted.sexp), col='purple', size=2, alpha=0.3) + 
  geom_text(vjust=-0.5,hjust=0.1) + 
  geom_point(data=d[c.list,], col='green', size=2) + 
  xlab("Rank Area") + ylab(expression(paste("Area (km"^2,")"))) +
  scale_y_log10(label=scientific_10) + 
  theme_bw(base_size=14)

ggsave(file.path(path.figures,'area_stretched_exp_fit.png'),
       dpi=220, width=5, height=4)
# subset(d, area>80000 & area<90000)
