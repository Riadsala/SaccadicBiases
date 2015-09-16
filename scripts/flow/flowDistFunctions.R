
library(dplyr)
library(mvtnorm)
library(tmvtnorm)

#######
# functions for fitting flow distribution
#######

calcFlowOverSpace <- function(winSize, stepSize)
{
	# stFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu')), value=numeric())
	# snFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2')), value=numeric())
	nFitOverSpace =  data.frame(
		x=numeric(), 
		y=numeric(), 
		z=factor(levels=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yx', 'sigma_yy')), 
		value=numeric(),
		w=numeric())
	# calcualte how distribution parameters vary over a sliding window
	for (x in seq(-1+winSize, 1-winSize, stepSize))
	{
		print(x)
		for (y in round(seq(-.75+winSize, .75-winSize, stepSize),4))
		{	
			# get fixation that start in window
			fixations = filter(sacc, x1>x-winSize, x1<x+winSize, y1>y-winSize, y1<y+winSize)
			fixations = as.matrix(select(fixations, x2, y2))

			if (nrow(fixations)>1000)
			{

				# stFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'ST', x,y))
				# snFitOverSpace = rbind(snFitOverSpace, 	calcSNdist(sacc[idx,], 'SN',x,y))
				nFitOverSpace  = rbind(nFitOverSpace, 	calcNdist(fixations, x, y))
				nFitOverSpace  = rbind(nFitOverSpace, 	calcTNdist(fixations, x, y))
			}
		}
	}
	return(nFitOverSpace)
}

calcNdist <- function(fixations, x, y)
{
	mu_x = mean(fixations[,2])
	mu_y = mean(fixations[,1])
	sigma = var(fixations)
	nParams = data.frame(flowModel='N', x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(mu_x, mu_y, sigma[1,1], sigma[1,2], sigma[2,2]), w=nrow(fixations))
	return(nParams)
}

calcTNdist <- function(fixations, x, y, aspect.ratio=0.75)
{
 # start by guessing an (un-truncated) normal distrubtion 
 startFrom = list(mu=colMeans(fixations), sigma=var(fixations))
 # now fit truncated normal
 print(summary(fixations))
 m = mle.tmvnorm(fixations, 
 	lower=c(-1,-1), 
 	upper=c(1,1), 
 	start=startFrom)

  tnParams = data.frame(flowModel='tN', x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(coef(m)[1], coef(m)[2], coef(m)[3],coef(m)[4],coef(m)[5]), w=nrow(fixations))

	return(tnParams)
}

########
# sampling from flow distribution
########

generateScanPath <- function(nFix=10, flowModel='tN', init.fix = c(0,0))
{
	aspect.ratio = 0.75

	fixations = data.frame(
		n = 1:nFix,
		x1=rep(init.fix[1],nFix), 
		y1=rep(init.fix[2],nFix), 
		x2=rep(NaN,nFix), 
		y2=rep(NaN,nFix))


	flowParams = loadFlowParams(flowModel)
	
	# generate fixations
	for (ii in 1:(nFix-1))
	{
		# get distribution params for a saccade starting from this fixation
		params = getDistDefintion(fixations[ii,],flowParams)
		# sample next saccade
		z = sampleSaccade(params)
		fixations$x1[ii+1]  =z[1]
		fixations$x2[ii]  =z[1]
		fixations$y1[ii+1]  =z[2]
		fixations$y2[ii]  =z[2]

	}
	return(fixations)
}

sampleSaccade <- function(params, flowModel='tN', aspect.ratio=0.75)
{
	mu = c(params['mu_x'], params['mu_y'])
	# hack to make sigma diagonal >0
	params['sigma_xx'] = max(params['sigma_xx'],0.05)
	# now back to normal
	sigma = array(c(params['sigma_xx'], params['sigma_xy'], params['sigma_xy'], params['sigma_yy']), dim=c(2,2))

	z = rtmvt(
		n=1,
		mean=,
		sigma=sigma,
		lower=c(-1,-aspect.ratio),
		upper=c(1,aspect.ratio))

	return(z)
}

#######
# functions for getting distirbution for given fixation
#######

loadFlowParams <- function(flowModel)
{
	biasParams = read.csv(paste('../flow/models/ALL_flowModels_0.1.txt', sep=''))
	flowParams = filter(biasParams, biasModel==flowModel)
	return(flowParams)
}

getParamPoly <- function(sacc)
{   
	v = c(1, 
		sacc$x1, sacc$x1^2, sacc$x1^3, sacc$x1^4, 
		sacc$y1, sacc$y1^2, sacc$y1^3, sacc$y1^4)
	return(v)
}

getDistDefintion <- function(sacc, flowParams)
{
	parameters = unique(flowParams$feat)
	valuesForDist = rep(0, length(parameters))
	names(valuesForDist) = parameters

	v = getParamPoly(sacc)
	for (jj in 1:length(parameters))
	{
		parameter = parameters[jj]
		polyCoefs = filter(flowParams, feat==parameters[jj])$coef
		# print(polyCoefs)
		valuesForDist[as.character(parameter)] = v %*% polyCoefs
	}
	return(valuesForDist)
}

#######
# functions for calc LLH of sacc given flow model
#######

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

