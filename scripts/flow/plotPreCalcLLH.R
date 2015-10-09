library(ggplot2)
library(dplyr)
dat = read.csv('llhResults.txt')

datLOU = read.csv('LOU_results.txt')

for (d in datLOU$dataset)
{
	dat = rbind(dat, data.frame(
		dataset=d, 
		biasmodel='LOU', 
		logLik=filter(datLOU, dataset==d)$score,
		llhImprovOverUni = NA,
		improvOverC = NA))
}


plt  = ggplot(dat, aes(fill=biasmodel, y=logLik, x=biasmodel))
plt = plt + geom_bar(stat='identity', position='dodge') + facet_wrap(~dataset, scales='free')
plt = plt + scale_fill_brewer(palette="Set1") + theme_bw()
# plt = plt + scale_y_continuous(name='proportion of deviance', limits=c(0,1), expand=c(0,0))
plt = plt + scale_x_discrete(name='bias model', breaks=NULL)

ggsave('lou_llh.pdf')