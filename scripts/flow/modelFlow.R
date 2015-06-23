
library(sn)
library(ggplot2)
library(scales)
library(dplyr)


# unboundTransform <- function(x)
# {
# 	# converts fixations in [-1,1] space to [0,1]
# 	x = (x+1)/2
# 	# converts [0,1] to (-inf, inf)
# 	z = log(x/(1-x))
# 	return(z)
# }

# get saccade info
sacc = read.csv('clarke2013saccsMirrored.txt', header=FALSE)
names(sacc) = c("x1", "y1", "x2", "y2")

# sacc[,3:4] = unboundTransform(sacc[,3:4])
sacc = sacc[which(is.finite(sacc$x2)),]
sacc = sacc[which(is.finite(sacc$y2)),]
# # over a partition window
# n = 0.25
# ii = 0
# for (x in seq(-1+n, 1-n, 2*n))
# {
#  	ii = ii + 1
#  	jj = 0
#  	for (y in seq(-1+n, 1-n, 2*n))
# 	{	
# 		jj = jj + 1
# 	 	idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-n) & sacc$y1<(y+n))
# 	 	m = (selm(data=sacc[idx,], formula= cbind(x2,y2)~1, family='ST'))
# 		centralBias = extractSECdistr(m)
		
# 		png(paste('flowFigures/saccEndByX', ii, 'Y', jj, '.pdf', sep=''))
# 		plot(centralBias, main=NULL, xlim=c(-2,2), ylim=c(-2,2))
# 		dev.off()
# 	}
#  }



calcSNdist <- function(saccs, distType)
{
	flow = (selm(data=saccs, formula= cbind(x2,y2)~1, family=distType))
	flowDist = extractSECdistr(flow)
	rm(flow)
	if (distType=='ST')
	{
		snParams = data.frame(x=x, y=y, param=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu'),
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
		snParams = data.frame(x=x, y=y, param=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yy', 'alpha-x2', 'alpha-y2'),
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
	sigma = var(sacc[,3:4])
	nParams = data.frame(x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yy'),
		value = c(mu_x, mu_y, sigma[1,1], sigma[1,2], sigma[2,2]))
	return(nParams)
}

# calcualte how distribution parameters vary over a sliding window

stFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu')), value=numeric())
snFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2')), value=numeric())
nFitOverSpace =  data.frame(x=numeric(), y=numeric(), z=factor(levels=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yx', 'sigma_yy')), value=numeric())

n = 0.25
m = 0.05

for (x in seq(-1+n, 1-n, m))
{
 	print(x)
 	for (y in seq(-.8+n, .8-n, m))
	{	
	 	idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-n) & sacc$y1<(y+n))
	 	
	 	if (length(idx)>500)
	 	{
			stFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'ST'))
			snFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'SN'))
			nFitOverSpace  = rbind(nFitOverSpace, 	calcNdist(sacc[idx,]))
		}
	}
}


# backTransformXY <- function(dat)
# {
# 	dat$x = 2*(round(exp(dat$x)/(1+exp(dat$x)),3)-0.5)
# 	dat$y = 2*(round(exp(dat$y)/(1+exp(dat$y)),3)-0.5)
# 	dat$down = dat$y < 0
# 	return(dat)
# }

# stFitOverSpace = backTransformXY(stFitOverSpace)
# snFitOverSpace = backTransformXY(snFitOverSpace)
# nFitOverSpace  = backTransformXY(nFitOverSpace)

ys = sort(unique(stFitOverSpace$y))
ny = length(ys)
subsetParams = rbind(
	filter(stFitOverSpace, y==ys[1]),
	filter(stFitOverSpace, y==ys[ny]),
	filter(stFitOverSpace, y==ys[4]),
	filter(stFitOverSpace, y==ys[ny-3]),
	filter(stFitOverSpace, y==ys[7]),
	filter(stFitOverSpace, y==ys[ny-6]))

subsetParams$down = subsetParams$y<0

plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
plt = plt + geom_point() + geom_smooth(method='lm', formula=y~poly(x,4)) 
plt = plt + facet_wrap(down~param, ncol=8, scales='free') + theme_minimal()
ggsave('STparamsChagingOverSpace.pdf', width=14, height=6)

subsetParams = rbind(
	filter(nFitOverSpace, y==ys[1]),
	filter(nFitOverSpace, y==ys[ny]),
	filter(nFitOverSpace, y==ys[4]),
	filter(nFitOverSpace, y==ys[ny-3]),
	filter(nFitOverSpace, y==ys[7]),
	filter(nFitOverSpace, y==ys[ny-6]))

subsetParams$down = subsetParams$y<0

plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
plt = plt + geom_point() + geom_smooth(method='lm', formula=y~poly(x,4)) 
plt = plt + facet_wrap(down~param, ncol=8, scales='free') + theme_minimal()
ggsave('NparamsChagingOverSpace.pdf', width=14, height=6)


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

write.csv(paramDF, 'flowModels.txt')