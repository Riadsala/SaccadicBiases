library(tmvtnorm)
library(dplyr)

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


calcTNdist <- function(fixations, x, y)
{
 # start by guessing an (un-truncated) normal distrubtion 
 startFrom = list(mu=colMeans(fixations), sigma=var(fixations))
 # now fit truncated normal
 m = mle.tmvnorm(fixations, lower=c(-1,-1), upper=c(1,1), start=startFrom)

  tnParams = data.frame(flowModel='tN', x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(coef(m)[1], coef(m)[2], coef(m)[3],coef(m)[4],coef(m)[5]), w=nrow(fixations))

return(tnParams)
}