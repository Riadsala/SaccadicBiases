library(dplyr)
library(mvtnorm)

unboundTransform <- function(x, gamma)
{
	# converts fixations in [-1,1] space to [0,1]
	x =(x+1)/2 
	
	# converts [0,1] to (-inf, inf)
	z = log(x/(1-x), base=gamma)
	return(z)
}

# get saccade info
saccades = read.csv('saccs/clarke2013saccs.txt', header=FALSE)

# First transform fixations
# saccades[,5:6] = unboundTransform(saccades[,3:4])
names(saccades) = c("x1", "y1", "x2", "y2")


plot(saccades$x2, unboundTransform(saccades$x2,50))


mu = c(mean(fixs[,1]), mean(fixs[,2]))
sigma = var(fixs)
llhO = sum(log(dmvnorm(fixs, mu, sigma)))

ii = 0
llh = vector()
for (gamma in seq(1.1,50,0.5))
{
ii = ii + 1
fixs = select(saccades, x2, y2)
fixs = unboundTransform(fixs, gamma)
mu = c(mean(fixs[,1]), mean(fixs[,2]))
sigma = var(fixs)
llhT = log(dmvnorm(fixs, mu, sigma))
llh[ii] = sum(log(dmvnorm(fixs, mu, sigma)))

}
  plot(seq(1.1,50,0.5), llh/llhO)

