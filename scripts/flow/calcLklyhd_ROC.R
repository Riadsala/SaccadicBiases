library(dplyr)
library(ggplot2)
library(Matrix)
library(matrixcalc)
library(tmvtnorm)

pRegThreshold = seq(0, 1, 0.025)
regTresh_N_samples = 1000

N = 1000 # for bootstrapping
n_Rep = 1

source('flowDistFunctions.R')

makeLLHdat <- function(datasets, nr)
{
	ClassAccResults = data.frame(
		dataset=character(),
		biasmodel=character(),
		pReg = numeric(),
		logLik=numeric()
		)

	for (d in datasets)
	{
		print(d)

		if (d == 'Asher2013')
		{
			asp.rat = 0.80
		} else 	{
			asp.rat = 0.75
		}

		uniform_samples = cbind(2*runif(regTresh_N_samples)-1, 2*asp.rat*runif(regTresh_N_samples)-asp.rat)

		# get saccade info
		saccades = read.csv(paste('../../data/saccs/', d, 'saccs.txt', sep=''), header=FALSE)
	
		# First transform fixations
		# saccades[,5:6] = unboundTransform(saccades[,3:4])
		names(saccades) = c("n", "x1", "y1", "x2", "y2")

		saccades = filter(saccades, x2>-1, y2>-asp.rat, x2<1, y2<asp.rat)
		saccades = filter(saccades, x1>-1, y1>-asp.rat, x1<1, y1<asp.rat)
		saccades = filter(saccades, n>1)
		
		for (pReg in pRegThreshold)
		{
			for (kk in 1:n_Rep)
				{
					# sample n saccades 
					saccades_samples = saccades[sample(nrow(saccades), N),]				
		
		
					######################################################################################
					# first caculate log-likelihood of dataset given Clarke-Tatler 2014 central bias
					# also use best fit gaussian, and use uniform as baseline
					#####################################################################################
		
					fixs = select(saccades_samples, x2, y2)
		
					# uniformLLH = nrow(fixs)  * log(1/(4*asp.rat))
		
					# ClassAccResults = rbind(ClassAccResults, 
					# 	data.frame(
					# 		dataset=d, 
					# 		biasmodel='uniform', 
					# 		logLik=uniformLLH,
					# 		deltaLogLik=0))
		
	
							
					# CT2017
					mu = c(0,0)
					sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
		
					# determind LLH for which > values are in most likely region
					reg_llh = quantile(dtmvnorm(cbind(uniform_samples[,1], uniform_samples[,2]), mu, sigma,
				lower=c(-1,-asp.rat),
				upper=c(1,asp.rat), log=T), 1-pReg)
					# how many of our fixations fell inside this region?
					regAcc = mean(dtmvnorm(cbind(fixs$x2, fixs$y2), mu, sigma,
				lower=c(-1,-asp.rat),
				upper=c(1,asp.rat), log=T)>reg_llh)
		
					ClassAccResults = rbind(ClassAccResults, 
						data.frame(
							dataset=d, 
							biasmodel='CT2017', 
							pReg = pReg,
							acc = regAcc))
		

					# # CT2014
					# mu = c(0,0)
					# sigma = array(c(0.32,0,0,0.45*0.32), dim=c(2,2))
		
					# # determind LLH for which > values are in most likely region
					# reg_llh = quantile(dmvnorm(uniform_samples, mu, sigma), 1-pReg)
					# # how many of our fixations fell inside this region?
					# regAcc = mean(dmvnorm(fixs, mu, sigma)>reg_llh)
		
					# ClassAccResults = rbind(ClassAccResults, 
					# 	data.frame(
					# 		dataset=d, 
					# 		biasmodel='CT2014', 
					# 		pReg = pReg,
					# 		acc = regAcc))



					rm(mu, sigma, reg_llh)
		
		
					######################################################################################
					# now find out how much flow helps!
					#####################################################################################
				  
					flowModel = 'tN'
					trainedOn = "ALL"
					
					regAcc = mean(calcLLHofSaccades(saccades_samples, flowModel, trainedOn, asp.rat, pReg, uniform_samples)$acc)
		
					ClassAccResults = rbind(ClassAccResults, 
						data.frame(
							dataset=d, 
							biasmodel='flow', 
							pReg = pReg,
							acc = regAcc))
				}
			}
	}

	return(ClassAccResults)
} 


pltResults <- function(dat, nr)
{
	# aggregate over bootstraps
	ClassAccResults2 = (dat
		%>% group_by(dataset, biasmodel, pReg) 
		%>%	summarise(
			meanAcc = mean(acc),
			stddev = sd(acc),
			stderr = sd(acc)/sqrt(n_Rep),
			upper = meanAcc+1.96*stderr,
			lower = meanAcc-1.96*stderr))	

	# levels(ClassAccResults2$biasmodel)[2] = "flow"

	ClassAccResults2$biasmodel = factor(ClassAccResults2$biasmodel, levels(ClassAccResults2$biasmodel)[c(2,1,3)])


	plt  = ggplot(ClassAccResults2, aes(y=meanAcc, x=pReg, colour=biasmodel))
	plt = plt + geom_path()
	plt = plt + facet_wrap(~dataset, nrow=nr)
	plt = plt + scale_fill_brewer(palette="Set2") + theme_bw()
    plt = plt + scale_y_continuous(name= 'prop fixations falling inside predicted area', expand=c(0,0))
	plt = plt + scale_x_continuous(name='prop of stimulus area predicted', expand=c(0,0))
	plt = plt + geom_abline(slope=1, linetype=2) + theme(legend.justification=c(1,0), legend.position=c(1,0))

	# plt = plt + guides(fill=guide_legend(title="bias model"))


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


dat = makeLLHdat(datasets)
plt = pltResults(dat,4)
ggsave(paste('figs/llh_Training_ROC.pdf', sep=''), width=6, height=9)



datasets = c(
	'Jiang2014',
 'Clarke2009',
 'Asher2013',
 'Ehinger2007') #

dat = makeLLHdat(datasets)
plt = pltResults(dat,2)
ggsave(paste('figs/llh_Testing_ROC.pdf', sep=''), width=6, height=4.5)






