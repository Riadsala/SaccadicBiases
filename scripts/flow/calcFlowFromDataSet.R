calcFlowFromDataSet <- function(sacc, flowLabel, winSize, stepSize)
{
# remove first fixation/saccade
sacc = filter(sacc, n>1)
# remove fixations falling outside window
sacc = filter(sacc, y1<0.75, y1>-0.75, y2<0.75, y2>-0.75)
sacc = filter(sacc, x1<1, x1>-1, x2<1, x2>-1)
	


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
	ggsave(paste('figs/NparamsChagingOverSpace_', flowLabel, '_', flowM, '_', winSize, '.pdf', sep=''), width=14, height=6)
	rm(subsetParams, ys)
    
# insert heatmap plots here

	rm(modelData, paramModel_lm, paramModel_rlm)
}
detach("package:MASS", unload = T)

write.csv(paramDF, paste('models/', flowLabel, '_flowModels_', winSize, '.txt', sep=''))
}