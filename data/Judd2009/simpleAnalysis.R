library(ggplot2)
library(mvtnorm)
library(gplots)
# read in data

dat <- read.table("DatabaseCode/juddFixData_TrialSubjFixNXY.txt", sep=",")
names(dat) <- c("trial", "subject", "fix_n", "X", "Y", "imX", "imY")
dat$trial <- factor(dat$trial)
dat$subject <- factor(dat$subject)

dat$X <- dat$X - (dat$imX/2)
dat$Y <- dat$Y - (dat$imY/2)

dat$aspectRatio <- dat$imX/dat$imY

#simdata <- rmvnorm(104137, m, sigma)

#dat$simX = simdata[,1]
#dat$simY = simdata[,2]

#ggplot(dat, aes(x=X)) + geom_density(colour="blue") + geom_density(data=dat, aes(x=simX), colour = "red")
#ggsave("judd_fittedmvnX.png")
#ggplot(dat, aes(x=Y)) + geom_density(colour="blue") + geom_density(data=dat, aes(x=simY), colour = "red")
#ggsave("judd_fittedmvnY.png")


# bDat = data.frame(trial=numeric(0), X=numeric(0), nFix=numeric(0))
#for (t in 1:1003)
#{##
	#trialHist <- hist(dat$X[dat$trial==t], seq(-525,525, 50))
	#bDat = rbind(bDat, t(rbind(rep(t, 21), trialHist$breaks[1:21]+25, trialHist$counts)))
#} 
#names(bDat) <- c("trial", "X", "count")
#bDat$trial <- factor(bDat$trial)


bDat = data.frame(X=numeric(0), Y=numeric(0), nFix=numeric(0))
w = 50
breaks = seq(-525, 525, w)
nbins = length(breaks)-1
ctr <- 0
for (x in 1:nbins)
{
	for (y in 1:nbins)
	{
		ctr <- ctr + 1
		X = breaks[x]+w/2
		Y = breaks[y]+w/2
		count <- sum(dat$X>=breaks[x] & dat$X<breaks[x+1] & dat$Y>=breaks[y] & dat$Y<breaks[y+1])
		bDat[ctr,] = c(X,Y,count)

	}
}

bDat$X2 <- bDat$X^2
bDat$Y2 <- bDat$Y^2
bDat$R <- sqrt(bDat$X2 + bDat$Y2)


model <- glm(bDat$nFix ~  bDat$R, family=poisson)


