library(nnet)
library(dplyr)
library(ggplot2)

source('../flow/flowDistFunctions.R')

datF = read.table("../../data/Koehler2014/FreeViewing.txt", header=T)
datF$task = "freeview"

datO = read.table("../../data/Koehler2014/ObjectSearch.txt", header=T)
datO$task = "search"

datS = read.table("../../data/Koehler2014/SaliencyViewing.txt", header=T)
datS$task = "salience"

dat = rbind(datF, datO, datS)

# dat = select(dat, Sub, Image, Cond, X1, Y1, X2, Y2)
names(dat) = c("x1", "y1", "Sub", "Image", "n", "task")

dat$Sub = as.factor(dat$Sub)
dat$Image = as.factor(dat$Image)
dat$task = as.factor(dat$task)

dat$x1 = (dat$x1-200)/200
dat$y1 = (dat$y1-200)/200
dat$x2 = NaN
dat$y2 = NaN
dat$x2[1:(nrow(dat)-1)] = dat$x1[2:nrow(dat)]
dat$y2[1:(nrow(dat)-1)] = dat$y1[2:nrow(dat)]

dat = filter(dat, n<15, is.finite(x1), is.finite(y1), is.finite(x2), is.finite(y2))

asp.rat = 1


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
dat2 = aggregate(llh ~ Sub + Image + task, dat, "mean")
dat3 = aggregate(llh ~ task, dat2, "mean")

plt  = ggplot(dat2, aes(y=llh, x=task)) + geom_boxplot(notch=T, fill="gray")
plt = plt + theme_bw() + scale_y_continuous("mean log likelihood")
plt = plt + scale_x_discrete("task")
ggsave("kLLH.pdf", width=5, height=5)