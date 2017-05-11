library(mvtnorm)
library(tmvtnorm)
library(ggplot2)

n=1000
asp.rat = 0.75

fix = data.frame(x=seq(-1.5,1.5,0.001), y=0)

# CT2014
mu = c(0,0)
sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
ct2014 = dmvnorm(fix, mu, sigma)

fix2014 = fix
fix2014$model = 'ct2014'
fix2014$density = ct2014

# CT2017
mu = c(0,0)
sigma = array(c(0.32,0,0,0.45*0.32), dim=c(2,2))
ct2017 = dtmvnorm(cbind(fix$x, fix$y), mu, sigma,
				lower=c(-1,-asp.rat),
				upper=c(1,asp.rat))

fix2017 = fix
fix2017$model = 'ct2017'
fix2017$density = ct2017


df = rbind(fix2014, fix2017)
df$model = as.factor(df$model)
summary(df)

plt = ggplot(df, aes(x=x, y=density, colour=model))
plt = plt + geom_path()
plt = plt + theme_bw()
plt = plt + scale_x_continuous(breaks=c(-1,1), minor_breaks=0)
ggsave("ct2017fig.pdf", width=4, height=4)