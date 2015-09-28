rm(list = ls())

library(mvtnorm)
library(tmvtnorm)
library(sn)
library(plyr)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")

setwd("/Users/matthewstainer/Documents/Work/Papers/SaccadicBiases/scripts/heatmaps/SaccadicFlowMaps")
getwd()->returnhere
data=read.table(file='Data/ProcessedFixations.txt',header=F,sep=',')
colnames(data)<-c('participant','image','index','fix.start','fix.end','x','y')

##downsample for visualising now

# data=data.frame(x=c(50,390,760,400,700,500),
#                 y=c(70,76,76,300,500,120))

fixnum=6

downsample=10
data$x<-data$x/downsample
data$y<-data$y/downsample
x_width=800/downsample
y_height=600/downsample

#data<-subset(data,index!=1)
setwd("/Users/matthewstainer/Documents/Work/Papers/SaccadicBiases/scripts/flow/")
source('flowDistFunctions.R')

library(dplyr)


saccadesALL=c()
sacinfo=c()

for (j in 1:fixnum){
  print(j) 
  datax<-data[j,]
  nxt<-j+1
  data2<-data[nxt,]
  
xposn=datax$x
yposn=datax$y

xposn2=data2$x
yposn2=data2$y

 saccades=data.frame(x1=xposn,
                     x2=rep(1:x_width,each=y_height),
                     y1=yposn,
                     y2=rep(1:y_height,x_width))

saccades$x1=((saccades$x1-1)/(x_width-1))*2-1

saccades$x2=((saccades$x2-1)/(x_width-1))*2-1

saccades$y1=(((saccades$y1-1)/(y_height-1))*2-1)*0.75

saccades$y2=(((saccades$y2-1)/(y_height-1))*2-1)*0.75



llh=c()
progress_bar_text <- create_progress_bar("text")
progress_bar_text$init(nrow(saccades))

for (i in 1:nrow(saccades)){
  progress_bar_text$step()
  saccade=saccades[i,]
  llh<-c(llh,calcLLHofSaccade(saccade,'tN',loadFlowParams('tN')))
}

saccades$llh<-llh*(-1)
saccades$llh<-saccades$llh/max(saccades$llh)


saccades$fix<-j
saccades$llh2=sqrt(saccades$llh^2)
saccadesALL<-rbind(saccadesALL,saccades)

sacsx<-data.frame(xposn,yposn,xposn2,yposn2)
sacinfo=rbind(sacinfo,sacsx)

}


library(ggplot2)
library(directlabels)

saccadesALL$llh2=sqrt(saccadesALL$llh^2)

ggplot(saccadesALL,aes(x=x2,y=y2))+
  stat_contour( data = saccadesALL, geom='polygon',aes( x = x2, y = y2, z = llh2, fill = ..level.. ) )+
  
  #geom_raster()+
  geom_point(aes(x=x1[1],y=y1[1]))  +
  scale_fill_continuous(low='white',high='black')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))+
  theme(axis.text=element_blank(),
        axis.title=element_blank(),
        axis.ticks=element_blank())+
  facet_wrap(~fix)
  


  pal.1=colorRampPalette(c("black", "red", "yellow","white"), space="rgb")
   pal.2=colorRampPalette(c("black","black"), space="rgb")
   jet.colors <-
     colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                        "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))


data$llh=1
data$x=((data$x-1)/(x_width-1))*2-1
data$y=(((data$y-1)/(y_height-1))*2-1)*0.75

data = data[1:fixnum,]
data$fix=c(1:fixnum)
data$shape='S'

data2<-data.frame(participant=1,
                  image=25,
                  index=1,
                  fix.start=1,
                  fix.end=1,
                  x=c(data$x[2:6],NA),
                  y=c(data$y[2:6],NA),
                  llh=1,
                  fix=1:6,
                  shape='E')

datax<-rbind(data,data2)

datax<-datax[order(datax$fix),]

ggplot(saccadesALL,aes(x=x2,y=y2,z=llh*(-1),fill=llh*(-1)))+
  geom_raster()+
  
  scale_fill_gradientn(colours=pal.1(7))+
  scale_color_gradientn(colours=pal.2(7))+
  stat_contour( data = saccadesALL, aes( x = x2, y = y2, z = llh*(-1),colour=..level..))+
  
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))+
  theme(axis.text=element_blank(),
        axis.title=element_blank(),
        axis.ticks=element_blank())+
  geom_line(data=datax,aes(x=x,y=y))+
  geom_point(data=datax,aes(x=x,y=y,shape=shape),size=4,colour='black')+
  scale_shape_manual(values=c(16,1))+
  facet_wrap(~fix)

direct.label(g1)



#   

setwd(returnhere)
