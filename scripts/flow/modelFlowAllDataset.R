
library(sn)
library(ggplot2)
library(scales)
library(dplyr)


 datasets = c('Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search','Yun2013SUN', 'Judd2009') #, 'Yun2013PASCAL'


source('calcFlowDists.R')

sacc = data.frame(x1=numeric(), y1=numeric(), x2=numeric(), y2=numeric())

for (d in datasets)
{
	print(d)
	# get saccade info
	dsacc = read.csv(paste('saccs/', d, 'saccsMirrored.txt', sep=''), header=FALSE)
	names(dsacc) = c("x1", "y1", "x2", "y2")
	sacc = rbind(sacc, dsacc)
}
	
	# calcualte how distribution parameters vary over a sliding window

	stFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu')), value=numeric())
	snFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2')), value=numeric())
	nFitOverSpace =  data.frame(x=numeric(), y=numeric(), z=factor(levels=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yx', 'sigma_yy')), value=numeric())

	for (n in c(0.05, 0.1, 0.2, 0.25))
	{
	m = 0.05

	for (x in seq(-1+n, 1-n, m))
	{
		print(x)
		for (y in seq(-.75+n, .75-n, m))
		{	
			idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-n) & sacc$y1<(y+n))

			if (length(idx)>250)
			{
				# stFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'ST', x,y))
				 # snFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'SN',x,y))
				nFitOverSpace  = rbind(nFitOverSpace, 	calcNdist(sacc[idx,]))
			}
		}
	}


	 ys = sort(unique(nFitOverSpace$y))
	 ny = length(ys)

	
	# subsetParams = rbind(
	# 	filter(snFitOverSpace, y==ys[1]),
	# 	filter(snFitOverSpace, y==ys[ny]),
	# 	filter(snFitOverSpace, y==ys[4]),
	# 	filter(snFitOverSpace, y==ys[ny-3]),
	# 	filter(snFitOverSpace, y==ys[7]),
	# 	filter(snFitOverSpace, y==ys[ny-6]))

	# subsetParams$down = subsetParams$y<0

	# plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
	# plt = plt + geom_point() + geom_smooth(method='lm', formula=y~poly(x,4)) 
	# plt = plt + facet_wrap(down~param, ncol=8, scales='free') + theme_minimal()
	# ggsave('SNparamsChagingOverSpace.pdf', width=14, height=6)


	subsetParams = rbind(
		filter(nFitOverSpace, y==ys[1]),
		filter(nFitOverSpace, y==ys[ny]),
		filter(nFitOverSpace, y==ys[4]),
		filter(nFitOverSpace, y==ys[ny-3]),
		filter(nFitOverSpace, y==ys[7]),
		filter(nFitOverSpace, y==ys[ny-6]))

	subsetParams$down = subsetParams$y<0

	plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
	plt = plt + geom_point() + geom_smooth(method='lm', formula=y~I(x)+I(x^2war)+I(x^3)+I(x^4)) 
	plt = plt + facet_wrap(down~param, ncol=5, scales='free') + theme_minimal()
	ggsave(paste('figs/NparamsChagingOverSpace_ALL_', n, '.pdf'), width=14, height=6)


	# Try and model how these parameters vary over space
	paramDF = data.frame(biasModel=character(), feat=character(), z=character(), coef=numeric())
	for (feat in levels(stFitOverSpace$param))
	{
		param = filter(stFitOverSpace, param==feat)
		paramModel = lm(value ~ x + I(x^2)+ I(x^3) + I(x^4) + y + I(y^2)+ I(y^3) + I(y^4), param)
		paramDF = rbind(paramDF, 
			data.frame(
				biasModel='ST', 
				feat=feat,z=names(coef(paramModel)), 
				coef=as.numeric(coef(paramModel))))
	}	
	for (feat in levels(snFitOverSpace$param))
	{
		param = filter(snFitOverSpace, param==feat)
		paramModel = lm(value ~ x + I(x^2)+ I(x^3) + I(x^4) + y + I(y^2)+ I(y^3) + I(y^4), param)
		paramDF = rbind(paramDF, 
			data.frame(
				biasModel='SN', 
				feat=feat,z=names(coef(paramModel)), 
				coef=as.numeric(coef(paramModel))))
	}	
	for (feat in levels(nFitOverSpace$param))
	{
		param = filter(nFitOverSpace, param==feat)
		paramModel = lm(value ~ x + I(x^2)+ I(x^3) + I(x^4) + y + I(y^2)+ I(y^3) + I(y^4), param)
		paramDF = rbind(paramDF, 
			data.frame(
				biasModel='N', 
				feat=feat,z=names(coef(paramModel)), 
				coef=as.numeric(coef(paramModel))))
	}	

	write.csv(paramDF, paste('models/', 'ALL_flowModels_', n, '.txt', sep=''))
}