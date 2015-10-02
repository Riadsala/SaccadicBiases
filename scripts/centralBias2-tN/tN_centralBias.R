library(dplyr)

source('../flow/flowDistFunctions.R')


datasets = c(
'Clarke2013', 
'Einhauser2008', 
'Tatler2005', 
'Tatler2007freeview', 
'Tatler2007search',
'Yun2013SUN', 
'Yun2013PASCAL'
)


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

aspect.ratio = 0.75
sacc = filter(sacc, n>1)
fixations = as.matrix(select(sacc, x2, y2))


# Clarke-Tatler 2014
mu = c(0,0)
sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
llhCT2014 = (dmvnorm(x=fixations, mu, sigma))

# refit guassian
mu = c(mean(fixations[,1]), mean(fixations[,2]))
sigma = var(fixations)
llhReFit = sum(dmvnorm(x=fixations, mu, sigma, log=T))

# truncated normal
ntParams = calcTNdist(fixations, NaN, NaN)

mu = c(filter(ntParams, param=='mu_x')$value, filter(ntParams, param=='mu_y')$value)

sigma = array(c(
		filter(ntParams, param=='sigma_xx')$value, 
		filter(ntParams, param=='sigma_xy')$value,
		filter(ntParams, param=='sigma_xy')$value,
		filter(ntParams, param=='sigma_yy')$value),
		dim=c(2,2))

llhTN = sum(dtmvnorm(x=cbind(sacc$x2, sacc$y2), 
			mean=mu, sigma=sigma, 
			lower=c(-1,-aspect.ratio),
			upper=c(1,aspect.ratio), log=T))

# truncated normal rounded
mu = c(0,0)
sigma = round(sigma,2)
llhTNrounded = sum(dtmvnorm(x=cbind(sacc$x2, sacc$y2), 
			mean=mu, sigma=sigma, 
			lower=c(-1,-aspect.ratio),
			upper=c(1,aspect.ratio), log=T))

dat = data.frame(
	bias = c('Clarke Tatler (2014)', 're-fit to training data', 'truncated gaussian', 'rounded'),
	llhFrac = c(1, llhReFit/llhCT2014, llhTN/llhCT2014, llhTNrounded/llhCT2014))


library(ggplot2)

plt = ggplot(dat, aes(x=bias, y=llhFrac)) + geom_bar(stat='identity')