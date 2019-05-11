# fit stretched exponential function to
source('config.R')
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
nls(data = subset(d, rank.area>10 & rank.area<0.9*max(d$rank.area)),
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
nls(data = subset(d, rank.area>10 & rank.area<0.9*max(d$rank.area)),
    area ~ A*exp(-(rank.area/tau)^h),
    start = list(A = 3E6, tau = 28, h=1)) -> fit
summary(fit)

d$area.predicted.sexp = predict(fit, list(rank.area = d$rank.area))
# add exponential fit to the plot
ggplot(d, aes(rank.area, area)) +
  geom_point(col='red') + 
  geom_path(aes(y=area.predicted), col='blue') + 
  geom_path(aes(y=area.predicted.sexp), col='purple') + 
  scale_y_log10() + 
  theme_bw()

