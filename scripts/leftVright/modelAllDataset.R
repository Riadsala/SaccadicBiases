
library(ggplot2)
library(scales)
library(dplyr)
library(mvtnorm)

 datasets = c('Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search','Yun2013SUN', 'Judd2009', 'Yun2013PASCAL') #) #



sacc = data.frame(x1=numeric(), y1=numeric(), x2=numeric(), y2=numeric())

for (d in datasets)
{
	print(d)
	# get saccade info
	dsacc = read.csv(paste('../../data/saccs/', d, 'saccs.txt', sep=''), header=FALSE)
	names(dsacc) = c("n", "x1", "y1", "x2", "y2")
	sacc = rbind(sacc, dsacc)
	rm(dsacc)
}
	
plt = ggplot(filter(sacc, n<13), aes(x=as.factor(n), y=x1))
plt = plt + geom_boxplot(notch=T)
plt = plt + coord_flip()
plt = plt + scale_y_continuous(name="horizontal postion of fixation", breaks=c(-1,0,1))
plt = plt + scale_x_discrete(name="fixation number")
plt = plt + theme_bw()
plt = plt + geom_hline(yintercept=0, colour="red")
ggsave("graphs/leftrightbias.pdf", height=3, width=3)
	
plt = ggplot(filter(sacc, n<13), aes(x=as.factor(n), y=y1))
plt = plt + geom_boxplot(notch=T)
plt = plt + scale_y_continuous(name="vertical postion of fixation", breaks=c(-1,0,1))
plt = plt + scale_x_discrete(name="fixation number")
plt = plt + theme_bw()
plt = plt + geom_hline(yintercept=0, colour="red")
ggsave("graphs/updownbias.pdf", height=3, width=3)
	
# propOfDev = data.frame(n=numeric(), devRatio=numeric())
# llh = array()
# for (ii in 2:12)
# {	
# 	saccN = filter(sacc, n==ii)
# 	mu = c(mean(saccN$x1), mean(saccN$y1))
# 	sigma = var(cbind(saccN$x1, saccN$y1))
# 	llh[ii] = sum(log(dmvnorm(cbind(saccN$x1, saccN$y1), mu, sigma)))

# 	mu = c(0,0)
# 	llh0 = sum(log(dmvnorm(cbind(saccN$x1, saccN$y1), mu, sigma)))
# 	propOfDev = rbind(propOfDev, data.frame(n=ii, devRatio=llh[ii]/llh0))
	
# }

# plt = ggplot(propOfDev, aes(x=n,y=devRatio))
# plt = plt + geom_bar(stat='identity') 
# plt = plt + scale_x_continuous(name="fixation number", breaks=2:12)
# plt = plt + scale_y_continuous(name="proportion of deviance")
# plt = plt + theme_minimal()
# ggsave("graphs/devRatio.pdf", width=3, height=3)

# rm(sacc, saccN, llh0, llh, propOfDev, mu, sigma)

# # now compute per dataset!
# results = data.frame(dataset=character(), model=character(), llh=numeric())
# for (d in datasets)
# {
# 	print(d)
# 	sacc = read.csv(paste('../../data/saccs/', d, 'saccs.txt', sep=''), header=FALSE)
# 	names(sacc) = c("n", "x1", "y1", "x2", "y2")	
# 	# remove intial fixation
# 	sacc = filter(sacc, n>1)
# 	# get LLH of dataset allowing for wandering mean
# 	llh = 0
# 	llh0 = 0
# 	for (ii in 2:12)
# 	{	
# 		saccN = filter(sacc, n==ii)
# 		mu = c(mean(saccN$x1), mean(saccN$y1))
# 		sigma = var(cbind(saccN$x1, saccN$y1))
# 		llh = llh + sum(log(dmvnorm(cbind(saccN$x1, saccN$y1), mu, sigma)))
		
# 		# zero mean dist
# 		mu = c(0,0)
# 		llh0 = llh0 + sum(log(dmvnorm(cbind(saccN$x1, saccN$y1), mu, sigma)))
# 	}
# 	# now get LLH of dataset under Clarke-Tatler (2014)
# 	mu = c(0,0)
# 	sigma = array(c(0.22, 0, 0, 0.45*0.22), c(2,2))
# 	llhCT = sum(log(dmvnorm(cbind(sacc$x1, sacc$y1), mu, sigma))) 

# 	results = rbind(results, data.frame(
# 		dataset=d, 
# 		model=c('llh', 'llh0'),
# 		llh=c(-llh/llhCT,-llh0/llhCT)))
# }

# plt = ggplot(results, aes(x=dataset, y=-llh, fill=model))
# plt = plt + geom_bar(stat='identity', position=position_dodge())
# plt = plt + scale_y_continuous(name='proportion of deviance', limits=c(0,1))
# plt = plt + theme_minimal()
# ggsave('graphs/datasetComp.pdf', width=6, height=3)