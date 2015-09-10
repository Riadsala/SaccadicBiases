library(tmvtnorm)

calcFlowOverSpace <- function(n)
{
	# stFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu')), value=numeric())
	# snFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2')), value=numeric())
	nFitOverSpace =  data.frame(x=numeric(), y=numeric(), z=factor(levels=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yx', 'sigma_yy')), value=numeric())
	# calcualte how distribution parameters vary over a sliding window
	for (x in seq(-1+n, 1-n, m))
	{
		print(x)
		for (y in round(seq(-.75+n, .75-n, m),4))
		{	
			idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-n) & sacc$y1<(y+n))

			if (length(idx)>250)
			{
				fixations = cbind(sacc$x2, sacc$y2)
					# stFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'ST', x,y))
				# snFitOverSpace = rbind(snFitOverSpace, 	calcSNdist(sacc[idx,], 'SN',x,y))
				nFitOverSpace  = rbind(nFitOverSpace, 	calcNdist(fixations, x, y), calcTNdist(fixations, x, y))
			}
		}
	}
	return(nFitOverSpace)
}



calcNdist <- function(fix, x, y)
{
	mu_x = mean(fix[,2])
	mu_y = mean(fix[,1])
	sigma = var(fix)
	nParams = data.frame(x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(mu_x, mu_y, sigma[1,1], sigma[1,2], sigma[2,2]))
	return(nParams)
}


calcTNdist <- function(fix, x, y)
{
  m = mle.tmvnorm(fix, lower=c(-1,-1), upper=c(1,1), 
  	start=list(mu=colMeans(fix), sigma=var(fix)))
  tnParams = data.frame(x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(coef(m)[1], coef(m)[2], coef(m)[3],coef(m)[4],coef(m)[5]))

return(tnParams)
}