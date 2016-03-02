
library(dplyr)
library(mvtnorm)
library(tmvtnorm)

#######
# functions for fitting flow distribution
#######

calcFlowOverSpace <- function(winSize, stepSize)
{
	nFitOverSpace =  data.frame(
		n=numeric(),
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
			for (ni in seq(1, 10))
			{
				# get fixation that start in window
				fixations = filter(sacc, x1>x-winSize, x1<x+winSize, y1>y-winSize, y1<y+winSize, n==ni)
				fixations = as.matrix(select(fixations, x2, y2))

				if (nrow(fixations)>500)
				{
					nFitOverSpace  = rbind(nFitOverSpace, 	calcTNdist(fixations, x, y))
				}
			}
		}
	}
	return(nFitOverSpace)
}

calcNdist <- function(fixations, x, y)
{
	mu_x = mean(fixations[,1])
	mu_y = mean(fixations[,2])
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
 m = mle.tmvnorm(fixations, 
 	lower=c(-1,-aspect.ratio), 
 	upper=c( 1, aspect.ratio), 
 	start=startFrom)
coef(m)
  tnParams = data.frame(flowModel='tN', n=n, x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(coef(m)[1], coef(m)[2], coef(m)[3],coef(m)[4],coef(m)[5]), w=nrow(fixations))

	return(tnParams)
}

# calcTTdist <- function(fixations, x, y, aspect.ratio=0.75)
# {
#  # start by guessing an (un-truncated) normal distrubtion 
#  startFrom = list(mu=colMeans(fixations), sigma=var(fixations))
#  # now fit truncated normal
#  m = mle.tmvtnorm(fixations, 
#  	lower=c(-1, -aspect.ratio), 
#  	upper=c( 1,  aspect.ratio), 
#  	start=startFrom)

#   ttParams = data.frame(flowModel='tT', x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
# 		value = c(coef(m)[1], coef(m)[2], coef(m)[3],coef(m)[4],coef(m)[5]), w=nrow(fixations))

# 	return(ttParams)
# }

########
# sampling from flow distribution
########



generateScanPath <- function(nFix=10, flowModel='tN', init.fix = c(0,0), aspect.ratio = 0.75)
{
	
	fixations = data.frame(
		n = 1:nFix,
		x1=rep(init.fix[1],nFix), 
		y1=rep(init.fix[2],nFix), 
		x2=rep(NaN,nFix), 
		y2=rep(NaN,nFix))


	if (flowModel!='central')
	{
		# extract polynomial coefs that describe how mu, sigma, etc vary with saccadic start point
		flowParams = loadFlowParams(flowModel)
	}
	# generate fixations
	if (nFix>1)
	{
		for (ii in 1:(nFix-1))
		{
			if (flowModel=='central')
			{
				mu = c(0,0)
				sigma = array(c(0.3,0,0,0.12), dim=c(2,2))
				z = rtmvt(
					n=1,
					mean=mu,
					sigma=sigma,
					lower=c(-1,-aspect.ratio),
					upper=c(1,aspect.ratio))

			} else {

				# get distribution params for a saccade starting from this fixation
				params = getDist(fixations[ii,], flowParams)
				# sample next saccade
				z = sampleSaccade(params, flowModel)
			}
			
			fixations$x1[ii+1]  =z[1]
			fixations$x2[ii]    =z[1]
			fixations$y1[ii+1]  =z[2]
			fixations$y2[ii]    =z[2]
		}
	}
	ii = nFix
	if (flowModel=='central')
			{
				mu = c(0,0)
				sigma = array(c(0.3,0,0,0.12), dim=c(2,2))
				z = rtmvt(
					n=1,
					mean=mu,
					sigma=sigma,
					lower=c(-1,-aspect.ratio),
					upper=c(1,aspect.ratio))

			} else {

				# get distribution params for a saccade starting from this fixation
				params = getDist(fixations[ii,], flowParams)
				# sample next saccade
				z = sampleSaccade(params, flowModel)
			}
	fixations$x2[ii]    =z[1]
	fixations$y2[ii]    =z[2]
	return(fixations)
}

sampleSaccade <- function(params, flowModel='tN', aspect.ratio=0.75)
{
	if (flowModel=='tN')
	{
		mu = c(params['mu_x'], params['mu_y'])
		# hack to make sigma diagonal >0
		# params['sigma_xx'] = max(params['sigma_xx'],0.05)
		# now back to normal
		sigma = array(c(params['sigma_xx'], params['sigma_xy'], params['sigma_xy'], params['sigma_yy']), dim=c(2,2))
	 
		z = rtmvt(
			n=1,
			mean=mu,
			sigma=sigma,
			lower=c(-1,-aspect.ratio),
			upper=c(1,aspect.ratio))
	}
	else if (flowModel=='central')
	{
		mu = c(0,0)
		sigma = array(c(0.3,0,0,0.12), dim=c(2,2))

		z = rtmvt(
			n=1,
			mean=mu,
			sigma=sigma,
			lower=c(-1,-aspect.ratio),
			upper=c(1,aspect.ratio))
	}
	
	return(z)
	
}

#######
# functions for getting distribution for given fixation
#######

loadFlowParams <- function(flowModel, trainedOn='All', winSize=0.05)
{
	biasParams = read.csv(paste('../flow/models/', trainedOn, '_flowModels_', winSize, '.txt', sep=''))
	flowParams = filter(biasParams, biasModel==flowModel)
	rm(biasParams)
	return(flowParams)
}

getParamPoly <- function(sacc)
{   
	v = with(sacc, c(1, 
		y1, x1, x1^2, x1^3, x1^4, 
		y1^2, y1^3, y1^4,
		 x1*y1, x1^2*y1, x1^3*y1, x1^4*y1,
		        x1*y1^2, x1*y1^3, x1*y1^4))
	return(v)
}

getDist <- function(sacc, flowParams, useRobust=TRUE)
{
	parameters = unique(flowParams$feat)
	valuesForDist = rep(0, length(parameters))
	names(valuesForDist) = parameters

	v = getParamPoly(sacc)

	for (jj in 1:length(parameters))
	{
		parameter = parameters[jj]
		
		if (useRobust==TRUE)
		{
			polyCoefs = filter(flowParams, feat==parameters[jj])$coef_rlm
		}
		else
			{
			polyCoefs = filter(flowParams, feat==parameters[jj])$coef_lm
		}
		valuesForDist[as.character(parameter)] = v %*% polyCoefs
	}
	return(valuesForDist)
}

#######
# functions for calc LLH of sacc given flow model
#######

calcLLHofSaccade <- function(saccade, flowModel, flowParams, aspect.ratio=0.75)
{
	# get distribution params for a saccade starting from this fixation
	params = getDist(saccade, flowParams)
	
	mu = c(params['mu_x'], params['mu_y'])
	# hack to make sigma diagonal >0
	params['sigma_xx'] = max(params['sigma_xx'],0.05)
	# now back to normal
	sigma = array(c(params['sigma_xx'], params['sigma_xy'], params['sigma_xy'], params['sigma_yy']), dim=c(2,2))
 	# 
 	if (is.positive.definite(sigma)==FALSE)
	{
		sigma = nearPD(sigma, corr=T)
		# print(sigma)
 	# print(sigma$mat)
 		sigma = (as.array(sigma$mat))
	}
	# print(mu)
	# print(sigma)
	# print(is.positive.definite(sigma))

 	if (flowModel == 'tN')
 	{	
		llh = dtmvnorm(x=cbind(saccade$x2, saccade$y2), 
			mean=mu, sigma=sigma, 
			lower=c(-1,-aspect.ratio),
			upper=c(1,aspect.ratio), log=T)
		
	}
	else if (flowModel == 'N')
	{
		llh = dmvnorm(x=cbind(saccade$x2, saccade$y2), 
			mean=mu, sigma=sigma, log=T)
	}

	return(llh)
}

calcLLHofSaccades <- function(saccades, flowModel, trainedOn='All', aspect.ratio=0.75)
{
	# extract polynomial coefs that describe how mu, sigma, etc vary with saccadic start point
	flowParams = loadFlowParams(flowModel, trainedOn)

	for (ii in 1:nrow(saccades))
	{
		saccades$llh[ii] = calcLLHofSaccade(saccades[ii,], flowModel, flowParams, aspect.ratio)
	}
	return(saccades)
}

