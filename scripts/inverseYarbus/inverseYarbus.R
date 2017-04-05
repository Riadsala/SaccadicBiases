library(nnet)
library(dplyr)

source('../flow/flowDistFunctions.R')

dat = read.csv("../../data/Dodd/Saccades-pupZ-clust-cont.dat", sep='\t')
# dat = select(dat, Sub, Image, Cond, X1, Y1, X2, Y2)
names(dat)[1:7] = c("Sub", "Image", "Cond", "x1", "y1", "x2", "y2")

levels(dat$Cond) = c("freeview", "memorize", "preference", "search")

dat$x1 = (dat$x1-500)/500
dat$y1 = (dat$y1-400)/500
dat$x2 = (dat$x2-500)/500
dat$y2 = (dat$y2-400)/500

asp.rat = 0.8

saccades = dat

saccades = filter(saccades, x2>-1, y2>-asp.rat, x2<1, y2<asp.rat)
saccades = filter(saccades, x1>-1, y1>-asp.rat, x1<1, y1<asp.rat)


# CT2017
mu = c(0,0)
sigma = array(c(0.32,0,0,0.45*0.32), dim=c(2,2))
dat$llhCT2017 = (dtmvnorm(cbind(dat$x2, dat$y2), mu, sigma,
lower=c(-1,-asp.rat),
upper=c(1,asp.rat), log=T))

# get flow over scanpaths

flow = calcLLHofSaccades(dat, flowModel='tN')

names(dat)[3] = 'task'
dat = filter(flow, is.finite(flow$llh))
names(dat)[27] = "llhFlow"
dat = select(dat, Sub, Image, task, llhCT2017, llhFlow)




dat2 = (dat 
		%>% group_by(Sub, Image, task) 
		%>%	summarise(
			meanCT2017 = mean(llhCT2017),
			meanFlow   = mean(llhFlow)))

dat3 = dat2
names(dat3)[4:5] = c("llh", "model")
dat3[,5] = "CT2017"

dat4 = dat2
dat4[,4] = dat4[,5]
names(dat4)[4:5] = c("llh", "model")
dat4[,5] = "Flow"

dat5 = rbind(dat3,dat4)


plt  = ggplot(dat5, aes(y=llh, x=task, fill=model)) + geom_boxplot(notch=T)
plt = plt + theme_bw() + scale_y_continuous("mean log likelihood")
plt = plt + scale_x_discrete("task")
ggsave("millsLLH.pdf", width=5, height=5)
