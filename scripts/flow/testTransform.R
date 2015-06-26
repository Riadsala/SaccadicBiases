unboundTransform <- function(x)
{
	# converts fixations in [-1,1] space to [0,1]
	x = (x+1)/2
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
