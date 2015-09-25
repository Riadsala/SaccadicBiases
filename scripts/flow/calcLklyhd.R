
library(dplyr)
library(ggplot2)
library(Matrix)
library(matrixcalc)

source('flowDistFunctions.R')

datasets = c('Clarke2013')#, 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search') #'Judd2009', 'Yun2013SUN', 'Yun2013PASCAL'

LLHresults = data.frame(
	dataset=character(),
	biasmodel=character(),
	logLik=numeric(),
	llhFrac=numeric())

for (d in datasets)
{
	print(d)
	# get saccade info
	saccades = read.csv(paste('../../data/saccs/', d, 'saccs.txt', sep=''), header=FALSE)

	# First transform fixations
	# saccades[,5:6] = unboundTransform(saccades[,3:4])
	names(saccades) = c("n", "x1", "y1", "x2", "y2")

	saccades = filter(saccades, x2>-1, y2>-0.75, x2<1, y2<0.75)
	saccades = filter(saccades, x1>-1, y1>-0.75, x1<1, y1<0.75)
	saccades = filter(saccades, n>1)

	print(summary(saccades))
	
	######################################################################################
	# first caculate log-likelihood of dataset given Clarke-Tatler 2014 central bias
	# also use best fit gaussian
	#####################################################################################

	fixs = select(saccades, x2, y2)

	mu = c(0,0)
	sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
	llh = sum(log(dmvnorm(fixs, mu, sigma)))
	LLHresults = rbind(LLHresults, data.frame(
		dataset=d, biasmodel='Clarke-Tatler2014', logLik = llh, llhFrac=1))
	rm(llh, mu, sigma)


	mu = c(mean(fixs[,1]), mean(fixs[,2]))
	sigma = var(fixs)
	llh = sum(log(dmvnorm(fixs, mu, sigma)))
	llhFrac = llh/filter(LLHresults, dataset==d, biasmodel=='Clarke-Tatler2014')$logLik
	LLHresults = rbind(LLHresults, data.frame(
		dataset=d, biasmodel='re-fit', logLik = llh, llhFrac=llhFrac))
	rm(llh, mu, sigma)
	# LLHresults['best fit LM'] = logLik(lm(c(fixs$x2, fixs$y2)~1))
	# LLHresults['central SN'] = logLik(selm(data=fixs, formula= cbind(x2,y2)~1, family='SN'))
	# LLHresults['central ST'] = logLik(selm(data=fixs, formula= cbind(x2,y2)~1, family='ST'))

	######################################################################################
	# now find out how much flow helps!
	#####################################################################################
 	 trainedOn = 'All'

	flowModel = 'tN'
	

	saccades = calcLLHofSaccades(saccades, flowModel)

	LLHresults = rbind(LLHresults, data.frame(
		dataset=d, 
		biasmodel = paste(flowModel, trainedOn), 
		logLik=sum(saccades$llh),
		llhFrac=sum(saccades$llh/filter(LLHresults, dataset==d, biasmodel=='Clarke-Tatler2014')$logLik)))

 	flowModel = 'N'
 	saccades = calcLLHofSaccades(saccades, flowModel)

	LLHresults = rbind(LLHresults, data.frame(
		dataset=d, 
		biasmodel = paste(flowModel, trainedOn), 
		logLik=sum(saccades$llh),
		llhFrac=sum(saccades$llh/filter(LLHresults, dataset==d, biasmodel=='Clarke-Tatler2014')$logLik)))

}



pltDat = filter(LLHresults, biasmodel %in% c('re-fit', 'N All', 'tN All'))
pltDat$biasmodel = factor(pltDat$biasmodel)
levels(pltDat$biasmodel)=c('re-fit central', 'truncated gaussian', 'gaussian')
pltDat$biasmodel = factor(pltDat$biasmodel, levels=c('re-fit central', 'gaussian', 'truncated gaussian'))

plt  = ggplot(pltDat, aes(x=biasmodel, y=llhFrac, fill=dataset))
plt = plt + geom_bar(stat='identity', position='dodge')
plt = plt + scale_fill_brewer(palette="Set3") + theme_bw()
plt = plt + scale_y_continuous(name='proportion of deviance', limits=c(0,1), expand=c(0,0))
plt = plt + scale_x_discrete(name='bias model')
ggsave(paste('figs/llh_ALL.pdf', sep=''), width=6, height=4)


plt = ggplot(filter(LLHresults, !(biasmodel %in% c('Clarke-Tatler2014', 're-fit', 'flow ALL N'))), aes(x=biasmodel, y=logLik, fill=dataset))
plt = plt + geom_bar(stat='identity', position='dodge')
plt = plt + scale_fill_brewer(palette="Set3") + theme_bw()
plt = plt + scale_y_continuous(name='proportion of deviance', limits=c(0,1), expand=c(0,0))
plt = plt + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
ggsave(paste('figs/llh_crossDataset.pdf', sep=''), width=8, height=4)

write.csv(LLHresults, 'llhResults.txt', row.names=F)



