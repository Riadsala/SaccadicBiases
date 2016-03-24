library(nnet)
library(dplyr)

source('../flow/flowDistFunctions.R')

dat = read.csv("../../data/Dodd/Saccades-pupZ-clust-cont.dat", sep='\t')
# dat = select(dat, Sub, Image, Cond, X1, Y1, X2, Y2)
names(dat)[1:7] = c("Sub", "Image", "Cond", "x1", "y1", "x2", "y2")

levels(dat$Cond) = c("Freeview", "Memorize", "Preference", "Search")

dat$x1 = (dat$x1-500)/500
dat$y1 = (dat$y1-400)/500
dat$x2 = (dat$x2-500)/500
dat$y2 = (dat$y2-400)/500

asp.rat = 0.8

saccades = dat

saccades = filter(saccades, x2>-1, y2>-asp.rat, x2<1, y2<asp.rat)
saccades = filter(saccades, x1>-1, y1>-asp.rat, x1<1, y1<asp.rat)

# get flow over scanpaths
dat$llh= 0
for (person in levels(dat$Sub))
{
	for (image in levels(dat$Image))
	{
		scanpath = filter(dat, Sub==person, Image==image)
		if (nrow(scanpath)>0)
		{
			scanpath = calcLLHofSaccades(scanpath, flowModel='tN')
			dat$llh[which(dat$Sub==person & dat$Image==image)] = scanpath$llh
		}
	}
}

dat = filter(dat, is.finite(dat$llh))


library(ggplot2)
dat2 = aggregate(llh ~ Sub + Image + Cond, dat, "mean")
dat3 = aggregate(llh ~ Cond, dat2, "mean")

plt  = ggplot(dat2, aes(y=llh, x=Cond)) + geom_boxplot(notch=T, fill="gray")
plt = plt + theme_bw() + scale_y_continuous("mean log likelihood")
plt = plt + scale_x_discrete("task")
ggsave("millsLLH.pdf", width=5, height=5)
