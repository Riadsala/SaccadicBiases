
library(sn)
library(ggplot2)
library(scales)
library(dplyr)


# get saccade info
sacc = read.csv('clarke2013saccsMirrored.txt', header=FALSE)
names(sacc) = c("x1", "y1", "x2", "y2")
sacc = (sacc + 1)/2
sacc = log(sacc/(1-sacc))
sacc = sacc[-which(is.infinite(sacc$x1)),]
sacc = sacc[-which(is.infinite(sacc$x2)),]
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
		snParams = data.frame(x=x, y=y, param=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu'),
		value = c(
			slot(flowDist, 'dp')$xi[1], 
			slot(flowDist, 'dp')$xi[2],
			slot(flowDist, 'dp')$Omega['x2', 'x2'],
			slot(flowDist, 'dp')$Omega['x2', 'y2'],
			slot(flowDist, 'dp')$Omega['y2', 'x2'],
			slot(flowDist, 'dp')$Omega['y2', 'y2'],
			slot(flowDist, 'dp')$alpha['x2'],
			slot(flowDist, 'dp')$alpha['y2'],
			slot(flowDist, 'dp')$nu))
	}
	else
	{
		snParams = data.frame(x=x, y=y, param=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2'),
		value = c(
			slot(flowDist, 'dp')$xi[1], 
			slot(flowDist, 'dp')$xi[2],
			slot(flowDist, 'dp')$Omega['x2', 'x2'],
			slot(flowDist, 'dp')$Omega['x2', 'y2'],
			slot(flowDist, 'dp')$Omega['y2', 'x2'],
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
	nParams = data.frame(x=x, y=y, param=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yx', 'sigma_yy'),
		value = c(mu_x, mu_y, sigma[1,1], sigma[1,2], sigma[2,1], sigma[2,2]))
	return(nParams)
}

# calcualte how distribution parameters vary over a sliding window

stFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu')), value=numeric())
snFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2')), value=numeric())
nFitOverSpace =  data.frame(x=numeric(), y=numeric(), z=factor(levels=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yx', 'sigma_yy')), value=numeric())
n = 0.2
m = 0.2

for (x in seq(-5+n, 5-n, m))
{
 	for (y in seq(-2+n, 2-n, m))
	{	
	 	idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-n) & sacc$y1<(y+n))
	 	
	 	if (length(idx)>100)
	 	{
			stFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'ST'))
			snFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'SN'))
			nFitOverSpace  = rbind(nFitOverSpace, 	calcNdist(sacc[idx,]))
		}
	}
}


backTransformXY <- function(dat)
{
	dat$x = 2*(round(exp(dat$x)/(1+exp(dat$x)),3)-0.5)
	dat$y = 2*(round(exp(dat$y)/(1+exp(dat$y)),3)-0.5)
	dat$down = dat$y < 0
	return(dat)
}

stFitOverSpace = backTransformXY(stFitOverSpace)
snFitOverSpace = backTransformXY(snFitOverSpace)
nFitOverSpace  = backTransformXY(nFitOverSpace)

ys = sort(unique(stFitOverSpace$y))
ny = length(ys)
subsetParams = rbind(
	filter(stFitOverSpace, y==ys[1]),
	filter(stFitOverSpace, y==ys[ny]),
	filter(stFitOverSpace, y==ys[4]),
	filter(stFitOverSpace, y==ys[ny-3]),
	filter(stFitOverSpace, y==ys[7]),
	filter(stFitOverSpace, y==ys[ny-6]))



plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
plt = plt + geom_point(position='jitter') + geom_smooth(method='lm', formula=y~poly(x,4)) 
plt = plt + facet_wrap(down~param, ncol=9, scales='free') + theme_minimal()
ggsave('paramsChagingOverSpace.pdf', width=14, height=6)

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
			coef=as.numeric(round(coef(paramModel),2))))
}	
for (feat in levels(snFitOverSpace$param))
{
	param = filter(snFitOverSpace, param==feat)
	paramModel = lm(value ~ x + I(x^2)+ I(x^3) + I(x^4) + y + I(y^2)+ I(y^3) + I(y^4), param)
	paramDF = rbind(paramDF, 
		data.frame(
			biasModel='SN', 
			feat=feat,z=names(coef(paramModel)), 
			coef=as.numeric(round(coef(paramModel),2))))
}	
for (feat in levels(nFitOverSpace$param))
{
	param = filter(nFitOverSpace, param==feat)
	paramModel = lm(value ~ x + I(x^2)+ I(x^3) + I(x^4) + y + I(y^2)+ I(y^3) + I(y^4), param)
	paramDF = rbind(paramDF, 
		data.frame(
			biasModel='SN', 
			feat=feat,z=names(coef(paramModel)), 
			coef=as.numeric(round(coef(paramModel),2))))
}	

write.csv(paramDF, 'flowModels.txt')