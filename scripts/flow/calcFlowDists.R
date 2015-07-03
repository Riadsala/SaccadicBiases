calcSNdist <- function(saccs, distType, x0, y0)
{
	
	saccsT = saccs#unboundTransform(saccs)
	# print(nrow(saccsT))
	# print(sum(is.infinite(saccsT$x2)))
	flow = (selm(data=saccsT, formula= cbind(x2, y2)~1, family=distType))
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

calcNdist <- function(saccs)
{
	mu_x = mean(saccs[,3])
	mu_y = mean(saccs[,4])
	sigma = var(saccs[,3:4])
	nParams = data.frame(x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(mu_x, mu_y, sigma[1,1], sigma[1,2], sigma[2,2]))
	return(nParams)
}