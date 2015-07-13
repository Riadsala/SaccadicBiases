calcFlowOverSpace <- function(n)
{
	# stFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu')), value=numeric())
	# snFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2')), value=numeric())
	nFitOverSpace =  data.frame(x=numeric(), y=numeric(), z=factor(levels=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yx', 'sigma_yy')), value=numeric())
	# calcualte how distribution parameters vary over a sliding window
	for (x in seq(-1+n, 1-n, m))
	{
		
		for (y in round(seq(-.75+n, .75-n, m),4))
		{	
			idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-n) & sacc$y1<(y+n))

			if (length(idx)>250)
			{
				# stFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'ST', x,y))
				# snFitOverSpace = rbind(snFitOverSpace, 	calcSNdist(sacc[idx,], 'SN',x,y))
				nFitOverSpace  = rbind(nFitOverSpace, 	calcNdist(sacc[idx,], x, y))
			}
		}
	}
	return(nFitOverSpace)
}

calcSNdist <- function(saccs, distType, x0, y0)
{	
	
	saccs = unboundTransform(saccs)
	plot(saccs$x2, saccs$y2)
	flow = (selm(data=saccs, formula= cbind(x2, y2)~1, family=distType))
	flowDist = extractSECdistr(flow)
	rm(flow)
	if (distType=='ST')
	{
		snParams = data.frame(x=x0, y=y0, param=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu'),
			value = c(
				slot(flowDist, 'dp')$xi[1], 
				slot(flowDist, 'dp')$xi[2],
				slot(flowDist, 'dp')$Omega['x2', 'x2'],
				slot(flowDist, 'dp')$Omega['x2', 'y2'],
				slot(flowDist, 'dp')$Omega['y2', 'y2'],
				slot(flowDist, 'dp')$alpha['x2'],
				slot(flowDist, 'dp')$alpha['y2'],
				slot(flowDist, 'dp')$nu))
	}
	else
	{
		snParams = data.frame(x=x0, y=y0, param=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yy', 'alpha-x2', 'alpha-y2'),
			value = c(
				slot(flowDist, 'dp')$xi[1], 
				slot(flowDist, 'dp')$xi[2],
				slot(flowDist, 'dp')$Omega['x2', 'x2'],
				slot(flowDist, 'dp')$Omega['x2', 'y2'],
				slot(flowDist, 'dp')$Omega['y2', 'y2'],
				slot(flowDist, 'dp')$alpha['x2'],
				slot(flowDist, 'dp')$alpha['y2']))
	}

	return(snParams)
}

calcNdist <- function(saccs, x, y)
{
	mu_x = mean(saccs[,3])
	mu_y = mean(saccs[,4])
	sigma = var(saccs[,3:4])
	nParams = data.frame(x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(mu_x, mu_y, sigma[1,1], sigma[1,2], sigma[2,2]))
	return(nParams)
}

unboundTransform <- function(x)
{
	# converts fixations in [-1,1] space to [0,1]
	x = (x+1)/2
	# converts [0,1] to (-inf, inf)
	z = log(x/(1-x))
	return(z)
}