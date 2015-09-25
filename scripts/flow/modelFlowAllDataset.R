
# library(sn)
library(ggplot2)
library(scales)
library(dplyr)


datasets = c(
'Clarke2013', 
'Einhauser2008', 
'Tatler2005', 
'Tatler2007freeview', 
'Tatler2007search',
'Yun2013SUN', 
'Yun2013PASCAL')
#'Judd2009')

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
	
# remove first fixation/saccade
sacc = filter(sacc, n>1)
# remove fixations falling outside window
sacc = filter(sacc, y1<0.75, y1>-0.75, y2<0.75, y2>-0.75)
	
# define window sizel	
stepSize = 0.1
winSize  = 0.1

# calculate flow
nFitOverSpace = calcFlowOverSpace(winSize, stepSize)
print('fitted...')

# fit poloynomials to describe flow
library(MASS)
paramDF = data.frame(biasModel=character(), feat=character(), z=character(), coef=numeric())
for (flowM in levels(nFitOverSpace$flowModel))
{
	modelData = filter(nFitOverSpace, flowModel==flowM)
	modelData$Plm  = NaN
	modelData$Prlm = NaN

	# Try and model how these parameters vary over space
	for (feat in levels(modelData$param))
	{
		print(feat)
		param = filter(modelData, param==feat)

		paramModel_rlm = rlm(value ~ 
			y*(x + I(x^2)+ I(x^3) + I(x^4)) + 
			x*(y + I(y^2)+ I(y^3) + I(y^4)), 
			data=param, method='MM', maxit=200)

		paramModel_lm = lm(value ~ 
			y*(x + I(x^2)+ I(x^3) + I(x^4)) + 
			x*(y + I(y^2)+ I(y^3) + I(y^4)), 
			data=param)

		paramDF = rbind(paramDF, 
			data.frame(
				biasModel=flowM, 
				feat=feat,z=names(coef(paramModel_rlm)), 
				coef_lm=as.numeric(coef(paramModel_lm)),
				coef_rlm=as.numeric(coef(paramModel_rlm)) 
				))
		
		modelData$Plm[which(modelData$param==feat)]  = predict(paramModel_lm)
		modelData$Prlm[which(modelData$param==feat)] = predict(paramModel_rlm)
	}	

	ys = round(sort(unique(modelData$y)),4)

	subsetParams = filter(modelData, y%in%c(-0.35, 0.0, 0.25)) # -0.5, -0.25,0.0,0.4, 0.5
	
	plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
	plt = plt + geom_point() 
	plt= plt + geom_path(aes(y=Plm), linetype = 2)
	plt = plt + geom_path(aes(y=Prlm))
	plt = plt + facet_wrap(~param, ncol=5, scales='free') + theme_bw()
	ggsave(paste('figs/NparamsChagingOverSpace_ALL_', flowM, '_', winSize, '.pdf'), width=14, height=6)
	rm(subsetParams, ys)
    
# insert heatmap plots here

	rm(modelData, paramModel_lm, paramModel_rlm)
}
detach(MASS)

write.csv(paramDF, paste('models/', 'ALL_flowModels_', winSize, '.txt', sep=''))
