dat = read.csv('../../data/Clarke2013/ProcessedFixations.txt', header=FALSE)
names(dat) = c('person', 'image', 'fixnum', 'onset', 'offset', 'x', 'y')
# remove NAs
dat = dat[which(is.finite(dat$x) & is.finite(dat$y)),]


# normalise - unlike before, I am going to 
# log transform the data so that it is unbounded.
dat$x = (dat$x)/800
dat$y = (dat$y)/600

dat$x = log(dat$x/(1-dat$x))
dat$y = log(dat$y/(1-dat$y))

dat = dat[-which(is.infinite(dat$x)),]
dat = dat[-which(is.infinite(dat$y)),]

dat = dat[-which(dat$fixnum==1),]
# library(ggplot2)


# plt = ggplot(dat, aes(x=x, y=y))+stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE)
# plt = plt + scale_fill_gradient() 
# plt

library(sn)

m = (selm(data=dat, formula= cbind(x,y)~1, family='ST'))
centralBias = extractSECdistr(m)
show(centralBias)
plot(centralBias)

# get saccade info
sacc = read.csv('clarke2013saccs.txt', header=FALSE)
names(sacc) = c("x1", "y1", "x2", "y2")
sacc = (sacc + 1)/2
sacc = log(sacc/(1-sacc))
sacc = sacc[-which(is.infinite(sacc$x1)),]
sacc = sacc[-which(is.infinite(sacc$x2)),]
# over a partition window
n = 0.25
ii = 0
for (x in seq(-1+n, 1-n, 2*n))
{
 	ii = ii + 1
 	jj = 0
 	for (y in seq(-1+n, 1-n, 2*n))
	{	
		jj = jj + 1
	 	idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-n) & sacc$y1<(y+n))
	 	m = (selm(data=sacc[idx,], formula= cbind(x2,y2)~1, family='ST'))
		centralBias = extractSECdistr(m)
		
		png(paste('flowFigures/saccEndByX', ii, 'Y', jj, '.pdf', sep=''))
		plot(centralBias, main=NULL, xlim=c(-2,2), ylim=c(-2,2))
		dev.off()
	}
 }

# over a sliding window
params = data.frame(x=numeric(), y=numeric(), z=factor(levels=c('n', 'Omega-xx','Omega-xy','Omega-yy', 'alpha-x2', 'alpha-y2')), value=numeric())

n = 0.25
m = 0.05
ii = 0
for (x in seq(-1+n, 1-n, m))
{
 	ii = ii + 1
 	jj = 0
 	for (y in c(-0.5, 0, 0.5))
	{	
		jj = jj + 1
	 	idx = which(sacc$x1>(x-n) & sacc$x1<(x+n) & sacc$y1>(y-0.25) & sacc$y1<(y+.25))
	 	
	 	cm = (selm(data=sacc[idx,], formula= cbind(x2,y2)~1, family='ST'))
		centralBias = extractSECdistr(cm)
		rm(cm)
		params = rbind(params, 
			data.frame(x=x, y=y, z=c('n', 'Omega-xx','Omega-xy','Omega-yy', 'alpha-x2', 'alpha-y2'),
				value = c(length(idx),
					slot(centralBias, 'dp')$Omega['x2', 'x2'],
					slot(centralBias, 'dp')$Omega['x2', 'y2'],
					# slot(centralBias, 'dp')$Omega['y2', 'x2'],
					slot(centralBias, 'dp')$Omega['y2', 'y2'],
					slot(centralBias, 'dp')$alpha['x2'],
					slot(centralBias, 'dp')$alpha['y2'])))
	}
 }

 library(ggplot2)

plt = ggplot(params, aes(x=x, y=value, colour=as.factor(y)))
plt = plt + geom_point() + geom_smooth() + facet_wrap(~z, scales='free_y')
ggsave('paramsChagingOverSpace.pdf')
