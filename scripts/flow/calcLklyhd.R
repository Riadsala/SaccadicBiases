library(mvtnorm)
library(dplyr)

# unboundTransform <- function(x)
# {
# 	# converts fixations in [-1,1] space to [0,1]
# 	x = (x+1)/2
# 	# converts [0,1] to (-inf, inf)
# 	z = log(x/(1-x))
# 	return(z)
# }

# get saccade info
saccades = read.csv('clarke2013saccs.txt', header=FALSE)

# First transform fixations
# saccades[,5:6] = unboundTransform(saccades[,3:4])
names(saccades) = c("x1", "y1", "x2", "y2")
saccades = saccades[which(is.finite(saccades$x2)),]
saccades = saccades[which(is.finite(saccades$y2)),]
# saccades = saccades[which(is.finite(saccades$x3)),]
# saccades = saccades[which(is.finite(saccades$y3)),]

LLHresults = list()

######################################################################################
# first caculate log-likelihood of dataset given Clarke-Tatler 2014 central bias
# also use best fit gaussian
#####################################################################################

fixs = select(saccades, x2, y2)

mu = c(0,0)
sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
LLHresults['Clarke-Tatler2014'] = sum(log(dmvnorm(fixs, mu, sigma)))


mu = c(mean(fixs[,1]), mean(fixs[,2]))
sigma = var(fixs)
LLHresults['best fit normal'] = sum(log(dmvnorm(fixs, mu, sigma)))
LLHresults['best fit LM'] = logLik(lm(c(fixs$x2, fixs$y2)~1))
LLHresults['central SN'] = logLik(selm(data=fixs, formula= cbind(x2,y2)~1, family='SN'))
LLHresults['central ST'] = logLik(selm(data=fixs, formula= cbind(x2,y2)~1, family='ST'))


######################################################################################
# now find out how much flow helps!
#####################################################################################

getParamPoly <- function(sacc)
{
	v = c(1, 
		sacc$x1, sacc$x1^2, sacc$x1^3, sacc$x1^4, 
		sacc$y1, sacc$y1^2, sacc$y1^3, sacc$y1^4)
	return(v)
}


calcNormLLH <- function(sacc, v)
{
	fix = c(sacc$x2, sacc$y2)

	mu = c(v['mu_x'], v['mu_y'])
	sigma = array(c(v['sigma_xx'], v['sigma_xy'], v['sigma_xy'], v['sigma_yy']), dim=c(2,2))
	
	llh = log(dmvnorm(fix, mu, sigma))
	return(llh)
}

calcSkewNormalLLH <- function(sacc, v)
{
	fix = c(sacc$x2, sacc$y2)

	# dmsn(x, xi=rep(0,length(alpha)), Omega, alpha, tau=0, dp=NULL, log=FALSE)
	xi = c(v['xi_x'], v['xi_y'])
	Omega = array(c(v['Omega-xx'],v['Omega-xy'],v['Omega-xy'],v['Omega-yy']), dim=c(2,2))
	alpha = c(v['alpha-x2'], v['alpha-y2'])

	llh = dmsn(fix, dp=list(xi=xi, Omega=Omega, alpha=alpha),log=T)
}

biasParams = read.csv('flowModels.txt')

# Loop over flow models
for (flow in c('N', 'SN'))
{

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

	LLHresults[paste('flow', flow)] = sum(llh)
}

# now SN flow



LLH = data.frame(unlist(LLHresults))
LLH$model = names(LLHresults)
names(LLH)[1] = 'score'

plt  = ggplot(LLH, aes(x=model, y=score)) + geom_bar(stat='identity')
