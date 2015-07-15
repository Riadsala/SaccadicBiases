library(mvtnorm)
library(dplyr)
library(ggplot2)


	getParamPoly <- function(sacc)
	{   
		v = c(1, 
			sacc$x1, sacc$x1^2, sacc$x1^3, sacc$x1^4, 
			sacc$y1, sacc$y1^2, sacc$y1^3, sacc$y1^4)
		return(v)
	}


	calcNormLLH <- function(sacc, v)
	{
		fix = cbind(sacc$x2, sacc$y2)

		mu = c(v['mu_x'], v['mu_y'])
		sigma = array(c(v['sigma_xx'], v['sigma_xy'], v['sigma_xy'], v['sigma_yy']), dim=c(2,2))
		
		llh = log(dmvnorm(fix, mu, sigma))
		return(llh)
	}

	calcSkewNormalLLH <- function(sacc, v)
	{		
		fix = cbind(sacc$x2, sacc$y2)
		# dmsn(x, xi=rep(0,length(alpha)), Omega, alpha, tau=0, dp=NULL, log=FALSE)
		xi = c(v['xi_x'], v['xi_y'])
		Omega = array(c(v['Omega-xx'],v['Omega-xy'],v['Omega-xy'],v['Omega-yy']), dim=c(2,2))
		alpha = c(v['alpha-x2'], v['alpha-y2'])

		llh = dmsn(fix, dp=list(xi=xi, Omega=Omega, alpha=alpha),log=T)
	}

datasets = c('Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search',
	 'Judd2009', 'Yun2013SUN', 'Yun2013PASCAL')

LLHresults = data.frame(
	dataset=character(),
	biasmodel=character(),
	logLik=numeric())

for (d in datasets)
{
	print(d)
	# get saccade info
	saccades = read.csv(paste('saccs/', d, 'saccs.txt', sep=''), header=FALSE)

	# First transform fixations
	# saccades[,5:6] = unboundTransform(saccades[,3:4])
	names(saccades) = c("x1", "y1", "x2", "y2")
	# saccades = saccades[which(is.finite(saccades$x2)),]
	# saccades = saccades[which(is.finite(saccades$y2)),]
	# saccades = filter(saccades, x2>-1, y2>-1, x2<1, y2<1)

	

	######################################################################################
	# first caculate log-likelihood of dataset given Clarke-Tatler 2014 central bias
	# also use best fit gaussian
	#####################################################################################

	fixs = select(saccades, x2, y2)

	mu = c(0,0)
	sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
	llh = sum(log(dmvnorm(fixs, mu, sigma)))
	LLHresults = rbind(LLHresults, data.frame(
		dataset=d, biasmodel='Clarke-Tatler2014', logLik = llh))
	rm(llh, mu, sigma)


	mu = c(mean(fixs[,1]), mean(fixs[,2]))
	sigma = var(fixs)
	llh = sum(log(dmvnorm(fixs, mu, sigma)))/filter(LLHresults, dataset==d, biasmodel=='Clarke-Tatler2014')$logLik
	LLHresults = rbind(LLHresults, data.frame(
		dataset=d, biasmodel='re-fit', logLik = llh))
	rm(llh, mu, sigma)
	# LLHresults['best fit LM'] = logLik(lm(c(fixs$x2, fixs$y2)~1))
	# LLHresults['central SN'] = logLik(selm(data=fixs, formula= cbind(x2,y2)~1, family='SN'))
	# LLHresults['central ST'] = logLik(selm(data=fixs, formula= cbind(x2,y2)~1, family='ST'))

	######################################################################################
	# now find out how much flow helps!
	#####################################################################################
 
	for (fm in c('ALL', 'Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search',
	 'Judd2009', 'Yun2013SUN'))
	{
		if (fm=="ALL")
		{
		biasParams = read.csv(paste('models/ALL_flowModels_0.1.txt', sep=''))
		}
		else
		{
			biasParams = read.csv(paste('models/', fm, 'flowModels.txt', sep=''))	
		}


		flowParams = filter(biasParams, biasModel==flow)
		parameters = unique(flowParams$feat)

		llh = rep(0, nrow(saccades))
		for (ii in 1:nrow(saccades))
		{
			saccade = saccades[ii,]

			valuesForDist = rep(0, length(parameters))
			names(valuesForDist) = parameters

			v = getParamPoly(saccade)

			for (jj in 1:length(parameters))
			{
				parameter = parameters[jj]
				polyCoefs = filter(flowParams, feat==parameters[jj])$coef
				valuesForDist[as.character(parameter)] = v %*% polyCoefs
			}

			if (flow=='N') {
				llh[ii] = calcNormLLH(saccade, valuesForDist) 
			}
			else if (flow=='SN') {
				llh[ii] = calcSkewNormalLLH(saccade, valuesForDist)
			} 
		}
		llh = sum(llh[which(is.finite(llh))])/filter(LLHresults, dataset==d, biasmodel=='Clarke-Tatler2014')$logLik
		LLHresults = rbind(LLHresults, data.frame(
			dataset=d, biasmodel=paste('flow', fm, flow), logLik =llh))
	
		
		
	}
}

LLHresults$deviance = -2*LLHresults$logLik


plt  = ggplot(filter(LLHresults, biasmodel %in% c('re-fit', 'flow ALL N')), aes(x=biasmodel, y=logLik, fill=dataset))
plt = plt + geom_bar(stat='identity', position='dodge')
plt = plt + scale_fill_brewer(palette="Set3") + theme_bw()
plt = plt + scale_y_continuous(name='proportion of deviance', limits=c(0,1), expand=c(0,0))
plt = plt + scale_x_discrete(name='bias model', labels=c('re-fit central bias','normal flow (all)'))
ggsave(paste('figs/llh_ALL.pdf', sep=''), width=6, height=4)


plt = ggplot(filter(LLHresults, !(biasmodel %in% c('Clarke-Tatler2014', 're-fit', 'flow ALL N'))), aes(x=biasmodel, y=logLik, fill=dataset))
plt = plt + geom_bar(stat='identity', position='dodge')
plt = plt + scale_fill_brewer(palette="Set3") + theme_bw()
plt = plt + scale_y_continuous(name='proportion of deviance', limits=c(0,1), expand=c(0,0))
plt = plt + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
ggsave(paste('figs/llh_crossDataset.pdf', sep=''), width=8, height=4)

write.csv(LLHresults, 'llhResults.txt', row.names=F)



