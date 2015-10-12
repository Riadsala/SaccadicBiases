i
library(dplyr)
library(ggplot2)
library(Matrix)
library(matrixcalc)

source('flowDistFunctions.R')

datasets = c(
'Clarke2013', 
'Einhauser2008',
'Tatler2005', 
'Tatler2007freeview', 
'Tatler2007search',
'Judd2009', 
'Yun2013SUN',
 'Yun2013PASCAL',
 'Clarke2009',
 'Asher2013',
 'Ehinger2007') #


# 'Clarke2013'

LLHresults = data.frame(
	dataset=character(),
	biasmodel=character(),
	logLik=numeric(),
	llhImprovOverUni=numeric())

for (d in datasets)
{
	print(d)

	if (d == 'Asher2013')
	{
		asp.rat = 0.80
	} else 	{
		asp.rat = 0.75
	}

	# get saccade info
	saccades = read.csv(paste('../../data/saccs/', d, 'saccs.txt', sep=''), header=FALSE)

	# First transform fixations
	# saccades[,5:6] = unboundTransform(saccades[,3:4])
	names(saccades) = c("n", "x1", "y1", "x2", "y2")

	saccades = filter(saccades, x2>-1, y2>-asp.rat, x2<1, y2<asp.rat)
	saccades = filter(saccades, x1>-1, y1>-asp.rat, x1<1, y1<asp.rat)
	saccades = filter(saccades, n>1)

	######################################################################################
	# first caculate log-likelihood of dataset given Clarke-Tatler 2014 central bias
	# also use best fit gaussian, and use uniform as baseline
	#####################################################################################

	fixs = select(saccades, x2, y2)

	uniformLLH = nrow(fixs)  * log(1/(4*asp.rat))

	LLHresults = rbind(LLHresults, 
		data.frame(dataset=d, biasmodel='uniform', logLik=uniformLLH, llhImprovOverUni=0, improvOverC=0))
	

	# re-fit (use ase baseline)
	mu = c(mean(fixs[,1]), mean(fixs[,2]))
	sigma = var(fixs)
	llh = sum(log(dmvnorm(fixs, mu, sigma)))
	improv = llh - uniformLLH
	LLHresults = rbind(LLHresults, 
		data.frame(dataset=d, biasmodel='re-fit', logLik=llh, llhImprovOverUni=llh - uniformLLH, improvOverC=(llh-uniformLLH)/improv))
	rm(llh, mu, sigma)

	# CT2014
	mu = c(0,0)
	sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
	llh = sum(log(dmvnorm(fixs, mu, sigma)))

	LLHresults = rbind(LLHresults, data.frame(
		dataset=d, biasmodel='Clarke-Tatler2014', logLik = llh, llhImprovOverUni=llh - uniformLLH, improvOverC=(llh-uniformLLH)/improv))
	rm(llh, mu, sigma)




	######################################################################################
	# now find out how much flow helps!
	#####################################################################################
 
	trainedOn = 'All'
		flowModel = 'tN'

		saccades = calcLLHofSaccades(saccades, flowModel, trainedOn, asp.rat)
		llh = sum(saccades$llh)
		LLHresults = rbind(LLHresults, data.frame(
			dataset=d, 
			biasmodel = flowModel, 		
			logLik=sum(saccades$llh), llhImprovOverUni=llh - uniformLLH, improvOverC=(llh-uniformLLH)/improv))

	#  	flowModel = 'N'
	#  	saccades = calcLLHofSaccades(saccades, flowModel, trainedOn, asp.rat)

	# 	LLHresults = rbind(LLHresults, data.frame(
	# 		dataset=d, 
	# 		biasmodel = flowModel, 
	# 		trainOn = trainedOn,
	# 		logLik=sum(saccades$llh),
	# 		llhFrac=sum(saccades$llh/filter(LLHresults, dataset==d, trainOn=='-', biasmodel=='Clarke-Tatler2014')$logLik)))

}



pltDat = filter(LLHresults, biasmodel %in% c('Clarke-Tatler2014', 're-fit', 'N', 'tN'))
pltDat$biasmodel = factor(pltDat$biasmodel)
levels(pltDat$biasmodel)=c('CT2014', 're-fit central', 'truncated gaussian')
# pltDat$biasmodel = factor(pltDat$biasmodel, levels=c('re-fit central', 'gaussian', 'truncated gaussian'))

plt  = ggplot(LLHresults, aes(fill=biasmodel, y=logLik, x=biasmodel))
plt = plt + geom_bar(stat='identity', position='dodge') + facet_wrap(~dataset, scales='free')
plt = plt + scale_fill_brewer(palette="Set1") + theme_bw()
# plt = plt + scale_y_continuous(name='proportion of deviance', limits=c(0,1), expand=c(0,0))
plt = plt + scale_x_discrete(name='bias model', breaks=NULL)
ggsave(paste('figs/llh_ALL.pdf', sep=''), width=12, height=8)






