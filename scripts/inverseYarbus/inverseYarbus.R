library(nnet)
library(dplyr)

source('../flow/flowDistFunctions.R')

dat = read.csv("../../data/Dodd/Saccades-pupZ-clust-cont.dat", sep='\t')
# dat = select(dat, Sub, Image, Cond, X1, Y1, X2, Y2)
names(dat)[1:7] = c("Sub", "Image", "Cond", "x1", "y1", "x2", "y2")

levels(dat$Cond) = c("Freeview", "Memorize", "Preference", "Search")

dat$x1 = (dat$x1-500)/500
dat$y1 = (dat$y1-400)/500
dat$x2 = (dat$x2-500)/500
dat$y2 = (dat$y2-400)/500

asp.rat = 0.8

saccades = dat

saccades = filter(saccades, x2>-1, y2>-asp.rat, x2<1, y2<asp.rat)
saccades = filter(saccades, x1>-1, y1>-asp.rat, x1<1, y1<asp.rat)

# get flow over scanpaths
dat$llh= 0
for (person in levels(dat$Sub))
{
	for (image in levels(dat$Image))
	{
		scanpath = filter(dat, Sub==person, Image==image)
		if (nrow(scanpath)>0)
		{
			scanpath = calcLLHofSaccades(scanpath, flowModel='tN')
			dat$llh[which(dat$Sub==person & dat$Image==image)] = scanpath$llh
		}
	}
}

dat = filter(dat, is.finite(dat$llh))


library(ggplot2)
dat2 = aggregate(llh ~ Sub + Image + Cond, dat, "mean")
dat3 = aggregate(llh ~ Cond, dat2, "mean")

plt  = ggplot(dat2, aes(y=llh, x=Cond)) + geom_boxplot(notch=T, fill="gray")
plt = plt + theme_bw() + scale_y_continuous("mean log likelihood")
plt = plt + scale_x_discrete("task")
ggsave("millsLLH.pdf", width=5, height=5)

#  only keep least likely 50% of saccades (by flow)
datM = filter(dat, Cond=="M")
datM = filter(dat, llh<quantile(datM$llh, 0.75))
datK = filter(dat, Cond=="M")
datK = filter(dat, llh<quantile(datK$llh, 0.75))
datS = filter(dat, Cond=="M")
datS = filter(dat, llh<quantile(datS$llh, 0.75))
datP = filter(dat, Cond=="M")
datP = filter(dat, llh<quantile(datP$llh, 0.75))

dat2 = rbind(datM, datK, datS, datP)

# we're only working on aggregate into, so take mean of everthing
byTrial = group_by(dat2, Sub, Image)

adat = summarise(byTrial, 
	task = unique(Cond),
	lat=mean(Lat, na.rm=T),
	pupilZ=mean(PupilZ, na.rm=T),
	dur=mean(Dur, na.rm=T),
	amp=mean(Amp, na.rm=T),
	amp1b=mean(Amp1B, na.rm=T),
	amp2b=mean(Amp2B, na.rm=T),
	vel=mean(Vel, na.rm=T),
	ramp1b=mean(rAmp1B, na.rm=T),
	ramp2b=mean(rAmp2B, na.rm=T))


subjects = sample(levels(adat$Sub))
subj_cut = cut(1:length(levels(adat$Sub)),3, labels=c('sa', 'sb', 'sc'))

trials = sample(levels(adat$Image))
trial_cut = cut(1:length(levels(adat$Image)),3, labels=c('ta', 'tb', 'tc'))

acc = array(0, c(3,3))

results = data.frame(subject_fold=numeric(), trial_fold=numeric(),
	pred=character(), task=character(), prop=numeric())

for (c in 1:3)
{
	for (d in 1:3)
	{
		sc = c('sa', 'sb', 'sc')[c]
		dc = c('ta', 'tb', 'tc')[d]

		tr_set = filter(adat, 
			!Sub%in%(subjects[which(subj_cut==sc)]),
			!Image%in%(trials[which(trial_cut==dc)]))
		te_set = filter(adat, 
			Sub%in%(subjects[which(subj_cut==sc)]),
			Image%in%(trials[which(trial_cut==dc)]))

		m = multinom(task ~  lat + pupilZ + dur + amp + amp1b + amp2b + vel + ramp1b + ramp2b, tr_set)

		p = predict(m, te_set)
		
		# acc[c,d] = (mean(pFlow==te_set$task, na.rm=T))- (mean(p==te_set$task, na.rm=T))

		# get confusion matrix
		for (tp in c('K', 'M', 'P', 'S'))
		{
			for (tg in c('K', 'M', 'P', 'S'))
			{
				z = sum(te_set$task[which(p==tp)]==tg)/length(te_set$task[which(p==tp)])

				results = rbind(results, 
					data.frame(subject_fold=c, trial_fold=d,
						pred=tp, task=tg, prop=z))
			}
		}
	}
}

library(ggplot2)
results$case = c(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1)
plt = ggplot(results, aes(x=pred, y=prop, fill=task, alpha=case)) + geom_boxplot()
plt = plt + theme_bw() + ylab("proportion classified as") + xlab("model prediction") + scale_alpha_continuous(guide=FALSE)
ggsave("mnlr.pdf", width=8, height=6)

 aggregate(prop~pred, filter(results, case==1), "mean")

#   pred      prop
# 1    K 0.6315296
# 2    M 0.3414980
# 3    P 0.3151409
# 4    S 0.4309542
