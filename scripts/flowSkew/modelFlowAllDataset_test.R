
library(sn)
library(ggplot2)
library(scales)
library(dplyr)


 datasets = c('Clarke2013', 'Einhauser2008', 'Tatler2005', 'Tatler2007freeview', 'Tatler2007search','Yun2013SUN') #, 'Judd2009') #, 'Yun2013PASCAL'


source('calcFlowDists.R')

sacc = data.frame(x1=numeric(), y1=numeric(), x2=numeric(), y2=numeric())

for (d in datasets)
{
	print(d)
	# get saccade info
	dsacc = read.csv(paste('../../data/saccs/', d, 'saccsMirrored.txt', sep=''), header=FALSE)
	names(dsacc) = c("n", "x1", "y1", "x2", "y2")
	sacc = rbind(sacc, dsacc)
}
	

#  remove intial saccade
sacc = filter(sacc, n>1)

# transform
sacc$x2 = unboundTransform(sacc$x2)
sacc$y2 = unboundTransform(sacc$y2)

	
m = 0.05
w = 0.1
ctr = 0
for (x in seq(-1+n, 1-n, m))
	{
		ctr = ctr  +1
		print(x)
		y=0.2
		t_saccs = filter(sacc, x1>(x-w), x1<(x+w), y1>(y-w), y1<(y+w))
		plt = ggplot(t_saccs, aes(x=x2)) + geom_histogram()
		plt = plt + scale_x_continuous(limit=c(-5,5))
		ggsave(paste(ctr, 'xDist', x, '.png'))

	}


print('fitted...')

# ys = round(sort(unique(listFits$normal$y)),4)

# for (mdl in names(listFits))
# {

# 	print(mdl)
# 	df = as.data.frame(listFits[mdl])
# 	names(df) = c('x', 'y', 'param', 'value')
# 	subsetParams = filter(df, y%in%c(0.25,0.05,0.75))

# 	plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
# 	plt = plt + geom_point() + geom_smooth(method='lm', formula=y~I(x)+I(x^2)+I(x^3)+I(x^4)) 
# 	plt = plt + facet_wrap(~param, nrow=1, scales='free_y') + theme_minimal()
# 	ggsave(paste('figs/NparamsChagingOverSpace_', mdl, n, '.pdf'), width=14, height=6)
# 	rm(subsetParams)
# 	print('done plotting)')

# 	# Try and model how these parameters vary over space
# 	paramDF = data.frame(biasModel=character(), feat=character(), z=character(), coef=numeric())

# 	for (feat in levels(df$param))
# 	{
# 		param = filter(df, param==feat)
# 		paramModel = lm(value ~ x + I(x^2)+ I(x^3) + I(x^4) + y + I(y^2)+ I(y^3) + I(y^4), param)
# 		paramDF = rbind(paramDF, 
# 			data.frame(
# 				biasModel='N', 
# 				feat=feat,z=names(coef(paramModel)), 
# 				coef=as.numeric(coef(paramModel))))
# 	}	

# 	write.csv(paramDF, paste('models/', mdl, '_flowModels.txt', sep=''))

# }
