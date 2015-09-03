library(mvtnorm)
library(dplyr)
library(ggplot2)


getParamPoly <- function(fix1)
{   
	v = c(1, 
		fix$x, fix$x^2, fix$x^3, fix$x^4, 
		fix$y, fix$y^2, fix$y^3, fix$y^4)
	return(v)
}

calcNormLLH <- function(fix, v)
{
	
	mu = c(v['mu_x'], v['mu_y'])
	sigma = array(c(v['sigma_xx'], v['sigma_xy'], v['sigma_xy'], v['sigma_yy']), dim=c(2,2))
	
	llh = log(dmvnorm(fix, mu, sigma))
	return(llh)
}

# calcSkewNormalLLH <- function(sacc, v)
# {		
# 	fix = cbind(sacc$x2, sacc$y2)
# 	# dmsn(x, xi=rep(0,length(alpha)), Omega, alpha, tau=0, dp=NULL, log=FALSE)
# 	xi = c(v['xi_x'], v['xi_y'])
# 	Omega = array(c(v['Omega-xx'],v['Omega-xy'],v['Omega-xy'],v['Omega-yy']), dim=c(2,2))
# 	alpha = c(v['alpha-x2'], v['alpha-y2'])

# 	llh = dmsn(fix, dp=list(xi=xi, Omega=Omega, alpha=alpha),log=T)
# }

calcFlowLLH <- function(fixations, flow)
{

	# flow should equal 'N' for now

	biasParams = read.csv(paste('models/ALL_flowModels_0.1.txt', sep=''))

	flowParams = filter(biasParams, biasModel==flow)
	parameters = unique(flowParams$feat)

	llh = rep(0, nrow(fixations)-1)
	for (ii in 2:nrow(fixations))
	{
		fix1  = fixations[ii-1,]
		fix2 = fixations[ii,]

		valuesForDist = rep(0, length(parameters))
		names(valuesForDist) = parameters
		v = getParamPoly(fix1)

		for (jj in 1:length(parameters))
		{
			parameter = parameters[jj]
			polyCoefs = filter(flowParams, feat==parameters[jj])$coef
			valuesForDist[as.character(parameter)] = v %*% polyCoefs
		}

		if (flow=='N') {
			llh[ii] = calcNormLLH(fix2, valuesForDist) 
		}
		else if (flow=='SN') {
			llh[ii] = calcSkewNormalLLH(fix2, valuesForDist)
		} 
	}
	return(llh)	
}