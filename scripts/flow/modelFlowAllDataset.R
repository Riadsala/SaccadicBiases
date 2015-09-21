
library(sn)
library(ggplot2)
library(scales)
library(dplyr)


datasets = c('Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search','Yun2013SUN') #, 'Judd2009') #, 'Yun2013PASCAL'

source('flowDistFunctions.R')

# load in data
sacc = data.frame(x1=numeric(), y1=numeric(), x2=numeric(), y2=numeric())
for (d in datasets)
{
	print(d)
	# get saccade info
	dsacc = read.csv(paste('../../data/saccs/', d, 'saccsMirrored.txt', sep=''), header=FALSE)
	names(dsacc) = c("n", "x1", "y1", "x2", "y2")
	sacc = rbind(sacc, dsacc)
}
	
# remove first fixation/saccad
sacc = filter(sacc, n>1)
# remove fixations falling outside window
sacc = filter(sacc, y1<0.75, y1>-0.75, y2<0.75, y2>-0.75)
	
# define window size	
stepSize = 0.025
winSize=0.1

# calculate flow
nFitOverSpace = calcFlowOverSpace(winSize, stepSize)
print('fitted...')

# fit poloynomials to describe flow
paramDF = data.frame(biasModel=character(), feat=character(), z=character(), coef=numeric())
for (flowM in levels(nFitOverSpace$flowModel))
{
	modelData = filter(nFitOverSpace, flowModel==flowM)
	ys = round(sort(unique(modelData$y)),4)

	subsetParams = filter(modelData, y%in%c(-0.3,0.0,0.4))
	plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
	plt = plt + geom_point() + geom_smooth(method='lm', formula=y~I(x)+I(x^2)+I(x^3)+I(x^4)) 
	plt = plt + facet_wrap(~param, ncol=5, scales='free') + theme_minimal()
	ggsave(paste('figs/NparamsChagingOverSpace_ALL_', flowM, '_', winSize, '.pdf'), width=14, height=6)
	rm(subsetParams, ys)

	# Try and model how these parameters vary over space
	for (feat in levels(modelData$param))
	{
		param = filter(nFitOverSpace, param==feat)
		paramModel = lm(value ~ x + I(x^2)+ I(x^3) + I(x^4) + y + I(y^2)+ I(y^3) + I(y^4), param, weights=w)
		paramDF = rbind(paramDF, 
			data.frame(
				biasModel=flowM, 
				feat=feat,z=names(coef(paramModel)), 
				coef=as.numeric(coef(paramModel))))
	}	
	rm(modelData, paramModel)
}

write.csv(paramDF, paste('models/', 'ALL_flowModels_', winSize, '.txt', sep=''))
