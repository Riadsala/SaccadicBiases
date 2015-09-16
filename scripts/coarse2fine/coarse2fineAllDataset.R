
library(sn)
library(ggplot2)
library(scales)
library(dplyr)

getAggStats <- function(data)
{
	
	data = filter(data, n<maxFix+1)
	data$amp = with(data, sqrt((x1-x2)^2+(y1-y2)^2))	

	aggData = (data 
		%>% group_by(n) 
		%>% summarise(
			meanAmp=mean(amp), 
			nSaccs=length(amp), 
			sdDev=sd(amp), 
			sdErr=sdDev/sqrt(nSaccs),
			lower = meanAmp-1.96*sdErr,
			upper = meanAmp+1.96*sdErr))
	return(aggData)
}


 datasets = c('Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search','Yun2013SUN') #, 'Judd2009') #, 'Yun2013PASCAL'


source('calcFlowDists.R')

sacc = data.frame(x1=numeric(), y1=numeric(), x2=numeric(), y2=numeric())

for (d in datasets)
{
	print(d)
	# get saccade info
	dsacc = read.csv(paste('../../data/saccs/', d, 'saccsMirrored.txt', sep=''), header=FALSE)
	names(dsacc) = c("n", "x1", "y1", "x2", "y2")
	sacc = rbind(sacc, dsacc)
}
	
maxFix = 35




aggHuman = getAggStats(sacc)

library(ggplot2)


m=nls(data=sacc, amp-0.31~u/(u-v) * (exp(-v*(n-1)) - exp(-u*(n-1))), start=c(u=1, v=2))
p = predict(m, new=data.frame(n=1:(maxFix)))+0.31


plt = ggplot(aggHuman, aes(x=n, y=meanAmp)) + geom_point()
plt = plt + geom_errorbar(aes(ymin=lower, ymax=upper))
plt = plt + geom_path(aes(x=1:maxFix, y=p ))
plt = plt + theme_bw()
plt = plt + scale_x_discrete(name="saccade number", breaks=seq(0,maxFix,5))
plt = plt + scale_y_continuous(name="saccadic amplitude")
ggsave('saccAmpOverTime.pdf')

### now compare to sampling from flow!!!
source('../flow/flowDistFunctions.R')
nScanPaths = 100
simSaccs = data.frame()
for (sp in 1:nScanPaths)
{
	simSaccs = rbind(simSaccs, generateScanPath(nFix=40))
}


aggFlow = getAggStats(simSaccs)


plt = ggplot(aggFlow, aes(x=n, y=meanAmp)) + geom_point()
plt = plt + geom_errorbar(aes(ymin=lower, ymax=upper))
plt = plt + geom_path(aes(x=1:maxFix, y=p ))
plt = plt + theme_bw()
plt = plt + scale_x_discrete(name="saccade number", breaks=seq(0,maxFix,5))
plt = plt + scale_y_continuous(name="saccadic amplitude")
ggsave('saccAmpOverTimeFlow.pdf')

