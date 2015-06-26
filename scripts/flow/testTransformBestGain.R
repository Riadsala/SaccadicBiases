unboundTransform <- function(x, gamma)
{
	# converts fixations in [-1,1] space to [0,1]
	x =(x+1)/2 
	x = x*gamma + ((1-gamma)/2)
	# converts [0,1] to (-inf, inf)
	z = log(x/(1-x))
	return(z)
}

# get saccade info
saccades = read.csv('clarke2013saccs.txt', header=FALSE)

# First transform fixations
# saccades[,5:6] = unboundTransform(saccades[,3:4])
names(saccades) = c("x1", "y1", "x2", "y2")
saccades = saccades[which(is.finite(saccades$x2)),]
saccades = saccades[which(is.finite(saccades$y2)),]
saccades = filter(saccades, x2>-1, y2>-1, x2<1, y2<1)


plot(saccades$x2, unboundTransform(saccades$x2,0.5))
fixs = select(saccades, x2, y2)

mu = c(mean(fixs[,1]), mean(fixs[,2]))
sigma = var(fixs)
llhO = log(dmvnorm(fixs, mu, sigma))

ii = 0
llh = vector()
for (gamma in seq(0.1, 1, 0.01))
{
ii = ii + 1
fixs = unboundTransform(fixs, gamma)
mu = c(mean(fixs[,1]), mean(fixs[,2]))
sigma = var(fixs)
llhT = log(dmvnorm(fixs, mu, sigma))
llh[ii] = sum(log(dmvnorm(fixs, mu, sigma)))

}
  plot(llhO, llhT)

