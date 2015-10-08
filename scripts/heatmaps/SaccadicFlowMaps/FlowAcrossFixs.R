rm(list = ls())

library(mvtnorm)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")
library(matrixcalc)
library(plyr)


##this is a bit of a fudge as I don't know how to reference relative file sources
#setwd("/Users/matthewstainer/Documents/Work/Papers/SaccadicBiases/scripts/heatmaps/SaccadicFlowMaps")
getwd()->mattwd
setwd("../../../../SaccadicBiases/scripts/flow/")
source('flowDistFunctions.R')
alwd<-getwd()
setwd(mattwd)


##set width and height of data
x_width=800
y_height=600
aspRat=0.75

data=read.table(file='Data/ProcessedFixations.txt',header=F,sep=',')
colnames(data)<-c('participant','image','index','fix.start','fix.end','x','y')

#data<-subset(data,index!=1)
data$duration<-data$fix.end-data$fix.start

#imselect=c(3,4,5,6,7,9,12)
#imselect=1
#imselect=unique(data$image)
alldata<-c()
#imselect=1:100
imselect=1:3
for (im in imselect){
  
  px<-paste('running im: ',im,' of ',max(imselect),sep='')
  print(px)
  imnum=im
  data.sub<-subset(data,image==imnum)
  
  ##make duration weight
  data.sub$dur=data.sub$duration/max(data.sub$duration)
  
  ##make cent weight
  mu = c(0,0)
  sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
  
  
  fixs.x=(round(c(data.sub$x))/(x_width)*2)-1
  fixs.y=((round(c(data.sub$y))/(y_height)*2)-1)*0.75
  fixs=cbind(fixs.x,fixs.y)
  
  llh = dmvnorm(fixs, mu, sigma)
  
  #centweights=c(max(llh,na.rm=T)-llh)
  centweights=llh
  
  saccades=data.frame(x1=data.sub$x[1:(nrow(data.sub)-1)],
                      x2=data.sub$x[2:(nrow(data.sub))],
                      y1=data.sub$y[1:(nrow(data.sub)-1)],
                      y2=data.sub$y[2:(nrow(data.sub))])
  
  
  
  
  
  # 
  saccades$x1=((saccades$x1-1)/(x_width-1))*2-1
  saccades$x2=((saccades$x2-1)/(x_width-1))*2-1
  saccades$y1=(((saccades$y1-1)/(y_height-1))*2-1)*aspRat
  saccades$y2=(((saccades$y2-1)/(y_height-1))*2-1)*aspRat
  saccades[is.na(saccades)==T]<-(-5)
  
  xm=(-1)
  ym=-1*aspRat
  data.sub$refs<-0
  data.sub$refs[which(saccades$x1>xm | 
                        saccades$x1<1 | 
                        saccades$x2>xm|
                        saccades$x2<1 |
                        saccades$y1>ym |
                        saccades$y1<aspRat | 
                        saccades$y2>ym | 
                        saccades$y2<aspRat)]<-1
  
  

  setwd(alwd)
  llh=c()
  progress_bar_text <- create_progress_bar("text")
  progress_bar_text$init(nrow(saccades))
  
  for (i in 1:nrow(saccades)){
    progress_bar_text$step()
    saccade=saccades[i,]
    llh<-c(llh,calcLLHofSaccade(saccade,'tN',loadFlowParams('tN')))
  }
  
  setwd(mattwd)
  
  data.sub$llh<-c(NA,llh)
  #data.sub$llh<-data.sub$llh + min(data.sub$llh,na.rm=T)
  
  
  #refs<-which(data.sub$index==2)
  #refs=refs-1
  #refs=refs[2:length(refs)]
  
  #datax=data.sub[-refs,]
  datax=data.sub
  datax$cent<-centweights
  #datax=datax[2:(nrow(datax)-1),]
  #datax<-datax[datax$llh!='-Inf',]
  #datax<-datax[datax$llh!='Inf',]
  
  #datax$llh=datax$llh+min(datax$llh)
  #datax$llh<-sqrt(datax$llh^2)
  #datax$llh<-datax$llh/max(datax$llh)
  ##datax$llh<-datax$llh-min(datax$llh)
  #datax$llh
  
  alldata<-rbind(alldata,datax)
}


library(ggplot2)

alldatax<-subset(alldata,index!=1)
alldatax<-subset(alldatax,llh!='-Inf' & llh !='Inf')

alldatax<-subset(alldatax,refs==1)
#alldatax<-subset(alldatax,llh!=NaN)
#alldatax<-subset(alldatax,llh!=NA)

ggplot(alldatax,aes(x=index,y=llh))+
  geom_smooth()+
  theme_bw(20)


# 
# 
# m1<-lmer(duration~llh+cent+(1+llh+cent|participant)+(1+llh+cent|image)+(1+llh+cent|index),data=alldata)
# summary(m1)
# 
 mFLOW<-lmer(duration~llh+(1+llh|participant)+(1+llh|image)+(1+llh|index),data=alldatax)
 summary(mFLOW)
 mCENT<-lmer(duration~cent+(1+cent|participant)+(1+cent|image)+(1+cent|index),data=alldatax)
 summary(mCENT)
# 

 ggplot(alldatax,aes(x=llh,y=duration))+
   geom_point()+
   geom_smooth(method='lm')+
   theme_bw(20)+
   coord_cartesian(xlim=c(-5,2))

