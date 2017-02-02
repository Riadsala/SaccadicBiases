library(dplyr)
library(ggplot2)
library(Matrix)
library(matrixcalc)




source('flowDistFunctions.R')

makeLLHfig <- function(datasets, nr)
{
	LLHresults = data.frame(
		dataset=character(),
		biasmodel=character(),
		logLik=numeric(),
		deltaLogLik=numeric())

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

		# sample n saccades 
		N = 10 # for bootstrapping
		n_Rep = 10

		for (kk in 1:n_Rep)
		{
		saccades_samples = saccades[sample(nrow(saccades), N),]

		######################################################################################
		# first caculate log-likelihood of dataset given Clarke-Tatler 2014 central bias
		# also use best fit gaussian, and use uniform as baseline
		#####################################################################################

		fixs = select(saccades_samples, x2, y2)

		uniformLLH = nrow(fixs)  * log(1/(4*asp.rat))

		# LLHresults = rbind(LLHresults, 
		# 	data.frame(
		# 		dataset=d, 
		# 		biasmodel='uniform', 
		# 		logLik=uniformLLH,
		# 		deltaLogLik=0))

		# re-fit (use ase baseline)
		mu = c(mean(fixs[,1]), mean(fixs[,2]))
		sigma = var(fixs)
		llh = sum(log(dmvnorm(fixs, mu, sigma)))
		improv = llh - uniformLLH
		LLHresults = rbind(LLHresults, 
			data.frame(
				dataset=d, 
				biasmodel='re-fit', 
				logLik=llh,
				deltaLogLik=llh-uniformLLH))
		rm(llh, mu, sigma)

		# CT2014
		mu = c(0,0)
		sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
		llh = sum(log(dmvnorm(fixs, mu, sigma)))

		LLHresults = rbind(LLHresults, data.frame(
			dataset=d, 
			biasmodel='Clarke-Tatler2014', 
			logLik = llh,
			deltaLogLik = llh-uniformLLH))
		rm(llh, mu, sigma)


		######################################################################################
		# now find out how much flow helps!
		#####################################################################################
	 
		trainedOn = 'All'
			flowModel = 'tN'

			saccades_samples = calcLLHofSaccades(saccades_samples, flowModel, trainedOn, asp.rat)
			llh = sum(saccades_samples$llh)
			LLHresults = rbind(LLHresults, data.frame(
				dataset=d, 
				biasmodel = flowModel, 		
				logLik=sum(saccades_samples$llh),
				deltaLogLik = sum(saccades_samples$llh)-uniformLLH))
		}
	}


	# aggregate over bootstraps
	LLHresults2 = (LLHresults 
		%>% group_by(dataset, biasmodel) 
		%>%	summarise(
			meanLLH = mean(deltaLogLik),
			stddev = sd(deltaLogLik),
			stderr = sd(deltaLogLik)/sqrt(N),
			upper = meanLLH+1.96*stderr,
			lower = meanLLH-1.96*stderr))	


	levels(LLHresults2$biasmodel)[4] = "flow"

	LLHresults2$biasmodel = factor(LLHresults2$biasmodel, levels(LLHresults2$biasmodel)[c(3,2,4)])


	pltDat = filter(LLHresults2, biasmodel %in% c('Clarke-Tatler2014', 're-fit', 'N', 'tN'))
	pltDat$biasmodel = factor(pltDat$biasmodel)
	levels(pltDat$biasmodel)=c('CT2014', 're-fit central', 'truncated gaussian')
	# pltDat$biasmodel = factor(pltDat$biasmodel, levels=c('re-fit central', 'gaussian', 'truncated gaussian'))

	plt  = ggplot(LLHresults2, aes(fill=biasmodel, y=meanLLH, x=biasmodel, ymin=lower, ymax=upper))
	plt = plt + geom_point() + geom_errorbar()
	plt = plt + facet_wrap(~dataset, nrow=nr)
	plt = plt + scale_fill_brewer(palette="Set2") + theme_bw()
    plt = plt + scale_y_continuous(name= paste(expression(delta LLH)))
	plt = plt + scale_x_discrete(name='bias model')
	# plt = plt + guides(fill=guide_legend(title="bias model"))

	return(plt)

} 


datasets = c(
'Clarke2013', 
'Einhauser2008',
'Tatler2005', 
'Tatler2007freeview', 
'Tatler2007search',
'Judd2009', 
'Yun2013SUN',
 'Yun2013PASCAL') #


plt = makeLLHfig(datasets,2)
ggsave(paste('figs/llh_Training.pdf', sep=''), width=12, height=6)



datasets = c(
	'Jiang2014',
 'Clarke2009',
 'Asher2013',
 'Ehinger2007') #

plt = makeLLHfig(datasets, 1)
ggsave(paste('figs/llh_Testing.pdf', sep=''), width=12, height=3)






