
library(sn)
library(ggplot2)
library(scales)
library(dplyr)



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

# unboundTransform <- function(z)
# {
# 	z$x2 = (z$x2+1)/2
# 	z$x2 = log(z$x2/(1-z$x2))

# 	z$y2 = (z$y2+1)/2
# 	z$y2 = log(z$y2/(1-z$y2))

# 	z = z[is.finite(z$x2),]
# 		z = z[is.finite(z$y2),]
# 	return(z)
# }

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

# calcualte how distribution parameters vary over a sliding window

stFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2', 'nu')), value=numeric())
 snFitOverSpace = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('xi_x', 'xi_y', 'Omega-xx','Omega-xy','Omega-yx','Omega-yy', 'alpha-x2', 'alpha-y2')), value=numeric())
 nFitOverSpace =  data.frame(x=numeric(), y=numeric(), z=factor(levels=c('mu_x', 'mu_y', 'sigma_xx', 'sigma_xy', 'sigma_yx', 'sigma_yy')), value=numeric())

n = 0.2
m = 0.1

for (x in seq(-1+n, 1-n, m))
{
 	print(x)
 	for (y in seq(-.75+n, .75-n, m))
	{	
	 	idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-n) & sacc$y1<(y+n))
	 	
	 	if (length(idx)>500)
	 	{
			stFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'ST', x,y))
			snFitOverSpace = rbind(stFitOverSpace, 	calcSNdist(sacc[idx,], 'SN',x,y))
			nFitOverSpace  = rbind(nFitOverSpace, 	calcNdist(sacc[idx,]))
		}
	}
}


ys = sort(unique(stFitOverSpace$y))
ny = length(ys)

subsetParams = rbind(
	filter(snFitOverSpace, y==ys[1]),
	filter(snFitOverSpace, y==ys[ny]),
	filter(snFitOverSpace, y==ys[4]),
	filter(snFitOverSpace, y==ys[ny-3]),
	filter(snFitOverSpace, y==ys[7]),
	filter(snFitOverSpace, y==ys[ny-6]))
subsetParams$down = subsetParams$y<0

plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
plt = plt + geom_point() + geom_smooth(method='lm', formula=y~poly(x,4)) 
plt = plt + facet_wrap(down~param, ncol=8, scales='free') + theme_minimal()
ggsave('STparamsChagingOverSpace.pdf', width=14, height=6)

subsetParams = rbind(
	filter(snFitOverSpace, y==ys[1]),
	filter(snFitOverSpace, y==ys[ny]),
	filter(snFitOverSpace, y==ys[4]),
	filter(snFitOverSpace, y==ys[ny-3]),
	filter(snFitOverSpace, y==ys[7]),
	filter(snFitOverSpace, y==ys[ny-6]))

subsetParams$down = subsetParams$y<0

plt = ggplot(subsetParams, aes(x=x, y=value, colour=as.factor(y)))
plt = plt + geom_point() + geom_smooth(method='lm', formula=y~poly(x,4)) 
plt = plt + facet_wrap(down~param, ncol=8, scales='free') + theme_minimal()
ggsave('SNparamsChagingOverSpace.pdf', width=14, height=6)


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
plt = plt + facet_wrap(down~param, ncol=5, scales='free') + theme_minimal()
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