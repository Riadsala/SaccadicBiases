
# library(sn)
library(ggplot2)
library(scales)
library(dplyr)


# define window size	
stepSize = 0.05
winSize  = 0.05


datasets = c(
'Clarke2013', 
'Einhauser2008', 
'Tatler2005', 
'Tatler2007freeview', 
'Tatler2007search',
'Yun2013SUN', 
'Yun2013PASCAL',
)
#'Judd2009'

source('flowDistFunctions.R')
source('calcFlowFromDataSet.R')

# load in data
sacc = data.frame(x1=numeric(), y1=numeric(), x2=numeric(), y2=numeric())
for (d in datasets)
{
	print(d)
	# get saccade info
	dsacc = read.csv(paste('../../data/saccs/', d, 'saccsMirrored.txt', sep=''), header=FALSE)
	names(dsacc) = c("n", "x1", "y1", "x2", "y2")
	calcFlowFromDataSet(dsacc, d, winSize, stepSize)
	sacc = rbind(sacc, dsacc)
}


print('Fitting to ALL')
calcFlowFromDataSet(sacc, 'ALL', winSize, stepSize)
