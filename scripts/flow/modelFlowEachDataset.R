
library(sn)
library(ggplot2)
library(scales)
library(dplyr)

 datasets = c('Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search',
 	 'Yun2013SUN', 'Judd2009') #, 'Yun2013PASCAL'


source('calcFlowDists.R')

n=0.1
m=0.01

for (d in datasets)
{
	print(d)
	# get saccade info
	sacc = read.csv(paste('saccs/', d, 'saccsMirrored.txt', sep=''), header=FALSE)
	names(sacc) = c("x1", "y1", "x2", "y2")

	
	nFitOverSpace = calcFlowOverSpace(n)
	print('fitted...')
	ys = round(sort(unique(nFitOverSpace$y)),4)


	subsetParams = filter(nFitOverSpace, y%in%quantile(ys, c(0.2,0.5,0.7)))

	plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
	plt = plt + geom_point() + geom_smooth(method='lm', formula=y~I(x)+I(x^2)+I(x^3)+I(x^4)) 
	plt = plt + facet_wrap(~param, ncol=5, scales='free') + theme_minimal()
	ggsave(paste('figs/NparamsChagingOverSpace_ALL_', n, '.pdf'), width=14, height=6)
	rm(subsetParams)
	print('done plotting)')
	# Try and model how these parameters vary over space
	paramDF = data.frame(biasModel=character(), feat=character(), z=character(), coef=numeric())

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

	write.csv(paramDF, paste('models/', d, 'flowModels.txt', sep=''))

}