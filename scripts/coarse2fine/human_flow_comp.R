setwd("Documents/SaccadicBiases/scripts/coarse2fine/")


library(ggplot2)
library(scales)
library(dplyr)
library(mvtnorm)

getAggStats <- function(data)
{
	data = filter(data, n<maxFix+1)

	aggData = (data 
		%>% group_by(n, obs) 
		%>% summarise(
			meanAmp=mean(amp), 
			nSaccs=length(amp), 
			sdDev=sd(amp), 
			sdErr=sdDev/sqrt(nSaccs),
			lower = meanAmp-1.96*sdErr,
			upper = meanAmp+1.96*sdErr))
	return(aggData)
}

datasets = c(
'Clarke2013', 
'Einhauser2008', 
'Tatler2005', 
'Tatler2007freeview', 
'Tatler2007search',
'Yun2013SUN', 
'Yun2013PASCAL',
'Judd2009')

source('../flow/flowDistFunctions.R')

sacc = data.frame(x1=numeric(), y1=numeric(), x2=numeric(), y2=numeric())

for (d in datasets)
{
	print(d)
	# get saccade info
	dsacc = read.csv(paste('../../data/saccs/', d, 'saccs.txt', sep=''), header=FALSE)
	names(dsacc) = c("n", "x1", "y1", "x2", "y2")
	sacc = rbind(sacc, dsacc)
}
sacc$amp = with(sacc, sqrt((x1-x2)^2+(y1-y2)^2))/2
maxFix = 35

# aggHuman = getAggStats(sacc)


# m=nls(data=sacc, amp-0.31~u/(u-v) * (exp(-v*(n-1)) - exp(-u*(n-1))), start=c(u=1, v=2))
# p = predict(m, new=data.frame(n=1:(maxFix)))+0.31



### now compare to sampling from flow!!!


# first get list of scanpath lengths

scnPathN = sacc$n[c(which(sacc$n==1)[2:length(which(sacc$n==1))]-1, length(sacc$n))]


nScanPaths = length(scnPathN)


flowSacc = data.frame()
for (sp in 1:nScanPaths)
{
	flowSacc = rbind(flowSacc, generateScanPath(nFix=scnPathN[sp], flowModel="tN"))
}
flowSacc$amp = with(flowSacc, sqrt((x1-x2)^2+(y1-y2)^2))/2

# generate some points from central bias

centSacc = data.frame()
for (sp in 1:nScanPaths)
{
	centSacc = rbind(centSacc, generateScanPath(nFix=scnPathN[sp], flowModel="central"))
}
centSacc$amp = with(centSacc, sqrt((x1-x2)^2+(y1-y2)^2))/2

 
flowSacc$obs = "flow"
centSacc$obs = "central"
sacc$obs = "human"



aggFlow = getAggStats(rbind(flowSacc, sacc, centSacc))


pltDat = rbind(select(flowSacc, x2, y2, obs), select(sacc, x2, y2, obs),select(centSacc, x2, y2, obs))
pltX = ggplot(pltDat, aes(x=x2, colour=obs))
pltX = pltX + geom_density() + theme_bw() + theme(legend.position="none")
pltX = pltX + scale_x_continuous(name='x position', breaks=c(-1, 0,1))
pltX = pltX + scale_y_continuous(breaks=c(0.,0.25, 0.5, 0.75, 1))
ggsave('figs/xFixComparison.pdf', width=3, height=3)
pltY = ggplot(pltDat, aes(x=y2, colour=obs))
pltY = pltY + geom_density() + theme_bw()+ theme(legend.position="none")
pltY = pltY + scale_x_continuous(name='y position', breaks=c(-.75, 0,0.75))
pltY = pltY + scale_y_continuous(breaks=c(0.0, 0.5, 1, 1.5))
plyY = pltY + coord_flip()
ggsave('figs/yFixComparison.pdf', width=3, height=3)
rm(pltDat, pltX, pltY, z, mu, sigma)


plt = ggplot(filter(aggFlow, n<16), aes(x=n, y=meanAmp, colour=obs)) 
plt = plt + geom_point()
plt = plt + geom_errorbar(aes(ymin=lower, ymax=upper)) + geom_smooth(se=F)
plt = plt + theme_bw()+ theme(legend.position="none")
plt = plt + scale_x_discrete(name="saccade number", breaks=seq(0,maxFix,5))
plt = plt + scale_y_continuous(name="saccadic amplitude")
ggsave('figs/saccAmpOverTimeFlow.pdf', width=3, height=3)


ampDat = rbind(flowSacc, sacc, centSacc)
ampPlt = ggplot(ampDat, aes(x=amp, colour=obs)) + geom_density(alpha=0.5)
ampPlt = ampPlt + theme_bw() + scale_x_continuous(name="saccadic amplitude")
ampPlt = ampPlt + theme(legend.position="none")
ggsave('figs/ampSaccComparison.pdf', width=3, height=3)
