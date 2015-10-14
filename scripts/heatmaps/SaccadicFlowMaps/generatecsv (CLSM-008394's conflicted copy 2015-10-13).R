rm(list = ls())

library(mvtnorm)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")
library(matrixcalc)
library(plyr)
source('resizeImage.R')


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
pix_per_degree=100

data=read.table(file='Data/ProcessedFixations.txt',header=F,sep=',')
colnames(data)<-c('participant','image','index','fix.start','fix.end','x','y')

data<-subset(data,index!=1)
data$duration<-data$fix.end-data$fix.start

alldata<-c()

#imselect=unique(data$image)
#imselect=c(3,4,5,6,7,9,12)
imselect=1
for (im in imselect){
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
  
  centweights=c(1.078428-llh)
  
  

  saccades=data.frame(x1=data.sub$x[2:(nrow(data.sub))],
                      x2=data.sub$x[1:(nrow(data.sub)-1)],
                      y1=data.sub$y[2:(nrow(data.sub))],
                      y2=data.sub$y[1:(nrow(data.sub)-1)])
  
  saccades$x1=((saccades$x1-1)/(x_width-1))*2-1
  saccades$x2=((saccades$x2-1)/(x_width-1))*2-1
  saccades$y1=(((saccades$y1-1)/(y_height-1))*2-1)*0.75
  saccades$y2=(((saccades$y2-1)/(y_height-1))*2-1)*0.75
  saccades[is.na(saccades)==T]<-(-5)
  
  
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
  
  
  refs<-which(data.sub$index==2)
  refs=refs-1
  refs=refs[2:length(refs)]
  
  datax=data.sub[-refs,]
  datax=data.sub[-1,]
  datax=datax[1:(nrow(datax)-1),]
  datax<-datax[datax$llh!='-Inf',]
  datax<-datax[datax$llh!='Inf',]
  
  
  datax$llh=datax$llh-1.013675
  datax$llh<-sqrt(datax$llh^2)
  datax$llh<-datax$llh-min(datax$llh,na.rm=T)
  datax$llh<-datax$llh/sum(datax$llh,na.rm=T)
  
  
  alldata<-rbind(alldata,datax)
  
  drawfixmap(x = data.sub$x,y=data.sub$y,x_width=800,y_height=600,plot=F,weight = 1,reshape=F)->reg.map
  drawfixmap(x = data.sub$x,y=data.sub$y,x_width=800,y_height=600,plot=F,weight = 'dur',weights=data$dur,reshape=F)->dur.map
  drawfixmap(x = data.sub$x,y=data.sub$y,x_width=800,y_height=600,plot=F,weights=centweights,weight='cent',reshape=F)->cent.map
  drawfixmap(x = datax$x,y=datax$y,weights=datax$llh,weight='dur',x_width=800,y_height=600,plot=F,reshape=F)->bias.map
 
  m1<-resizeImage(reg.map,200,150)
  m2<-resizeImage(dur.map,200,150)
  m3<-resizeImage(cent.map,200,150)
  m4<-resizeImage(bias.map,200,150)
  
  write.csv(x = m1,file=paste('CSVs/image',im,'_fixmap_',pix_per_degree,'.csv',sep=''),row.names=F)
  write.csv(x = m2,file=paste('CSVs/image',im,'_durmap_',pix_per_degree,'.csv',sep=''),row.names=F)
  write.csv(x = m3,file=paste('CSVs/image',im,'_centmap_',pix_per_degree,'.csv',sep=''),row.names=F)
  write.csv(x = m4,file=paste('CSVs/image',im,'_flowmap_',pix_per_degree,'.csv',sep=''),row.names=F)
  
}







