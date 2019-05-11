# fit stretched exponential function to populations of countries
source('R/config.R')
library(ggplot2)

# load data
d = read.csv(file.path(path.output, FILE.data.world), 
             stringsAsFactors = FALSE)
file.path(path.output, FILE.data.world)
# rank by area
d$rank.pop[order(d$population, decreasing=TRUE)] = 1:nrow(d)

# plot data
ggplot(d, aes(rank.pop, population)) +
  geom_point(col='red') + 
  scale_y_log10() + 
  theme_bw()

# model with  exponential function
nls(data = subset(d, rank.pop>3 & rank.pop<0.8*max(d$rank.pop)),
    population ~ A*exp(-rank.pop/tau),
    start = list(A = 1E8, tau = 40)) -> fit
summary(fit)

d$pop.predicted = predict(fit, list(rank.pop = d$rank.pop))
# add exponential fit to the plot
ggplot(d, aes(rank.pop, population)) +
  geom_point(col='red') + 
  geom_path(aes(y=pop.predicted), col='blue') + 
  scale_y_log10() + 
  theme_bw()

# model with stretched exponential function
nls(data = subset(d, rank.pop>10 & rank.pop<0.5*max(d$rank.pop)),
    population ~ A*exp(-(rank.pop/tau)^h),
    start = list(A = 3.6E8, h=0.53, tau=8)) -> fit
d$pop.predicted.sexp = predict(fit, list(rank.pop = d$rank.pop))

#d$pop.predicted.sexp = 3E8*exp(-(d$rank.pop/100)^0.7)
summary(fit)

# label the y-axis with powers of 10
scientific_10 <- function(x) {
  parse(text=gsub("e", " %*% 10^", scales::scientific_format()(x)))
}

# make some labels for countries
d$cname = ""
c.list = c(grep("France",d$country.name), grep("Switzerland",d$country.name),
           grep("United Stat",d$country.name), grep("Madag",d$country.name),
           grep("Swazila",d$country.name), grep("Haiti",d$country.name),
           grep("Qat",d$country.name),grep("Nigeri",d$country.name))
d$cname[c.list] = d$country.name[c.list]

# add exponential fit to the plot
ggplot(subset(d, population>10000), 
       aes(rank.pop, population, label=cname)) +
  geom_point(col='red', size=1) +
  geom_line(aes(y=pop.predicted), col='blue') + 
  geom_line(aes(y=pop.predicted.sexp), col='purple', size=2, alpha=0.3) + 
  geom_text(vjust=-0.5,hjust=0.1) +
  geom_point(data=d[c.list,], col='green', size=2) + 
  xlab("Rank Population") + ylab(expression(paste("Population"))) +
  scale_y_log10(label=scientific_10, limits=c(2E4,1.5E9)) + 
  theme_bw(base_size=14)

ggsave(file.path(path.figures,'population_stretched_exp_fit.png'),
       dpi=220, width=5, height=4)
# subset(d, area>80000 & area<90000)
