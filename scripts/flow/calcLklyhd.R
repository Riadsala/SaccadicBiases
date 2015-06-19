library(mvtnorm)
library(dplyr)

# get saccade info
sacc = read.csv('clarke2013saccs.txt', header=FALSE)
names(sacc) = c("x1", "y1", "x2", "y2")

LLHresults = data.frame(
	biasModel=c('Clarke-Tatler2014', 'best-fit central', 'normal flow', 'skew-normal flow', 'skew-t flow'), 
	loglikelihood=rep(0,5))

######################################################################################
# first caculate log-likelihood of dataset given Clarke-Tatler 2014 central bias
# also use best fit gaussian
#####################################################################################

fixs = select(sacc, x2, y2)
mu = c(0,0)
sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
LLHresults$loglikelihood[1] = sum(log(dmvnorm(fixs, mu, sigma)))

mu = c(mean(fixs[,1]), mean(fixs[,2]))
sigma = var(fixs)
LLHresults$loglikelihood[2] = sum(log(dmvnorm(fixs, mu, sigma)))


######################################################################################
# now find out how much flow helps!
#####################################################################################