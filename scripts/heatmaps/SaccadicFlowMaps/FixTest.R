rm(list = ls())

library(mvtnorm)
library(tmvtnorm)
library(sn)
library(plyr)
library(matrixcalc)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")

getwd()->mattwd
setwd("../../../../SaccadicBiases/scripts/flow/")
source('flowDistFunctions.R')
alwd<-getwd()
setwd(mattwd)
#data=read.table(file='Data/ProcessedFixations.txt',header=F,sep=',')
#colnames(data)<-c('participant','image','index','fix.start','fix.end','x','y')

##downsample for visualising now

 data=data.frame(x=c(133,400,667),
                 y=rep(c(100,300,100),each=3))

fixnum=9

downsample=10
data$x<-data$x/downsample
data$y<-data$y/downsample
x_width=800/downsample
y_height=600/downsample

#data<-subset(data,index!=1)
setwd(alwd)
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


pal.1=colorRampPalette(c("white","yellow","red","black"), space="rgb")

jet.colors <-
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

data$x=((data$x-1)/(x_width-1))*2-1

data$y=(((data$y-1)/(y_height-1))*2-1)*0.75

for (i in 1:9){
  sacdat<-subset(saccadesALL,fix==i)
  
 g0<-c() 
g0<-ggplot(sacdat,aes(x=x2,y=y2))+
  #stat_contour( data = saccadesALL, geom='polygon',aes( x = x2, y = y2, z = llh2, fill = ..level.. ) )+
  
  geom_raster(aes(fill=llh))+
  scale_fill_gradientn(colours=pal.1(10))+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))+
  theme(axis.text=element_blank(),
        axis.title=element_blank(),
        axis.ticks=element_blank())

g0<-g0+ geom_point(data=data,aes(x=x[i],y=y[i]),size=8,shape=1)

savename=paste('pos_', i , '.pdf',sep='')
  ggsave(filename = savename,plot = g0, path = 'FlowMaps',width = 8,height=6,unit='in')

}



ggplot(saccadesALL,aes(x=x2,y=y2,fill=llh))+
  stat_contour( data = saccadesALL, geom='polygon',aes( x = x2, y = y2, z = llh2, fill = ..level.. ) )+
  
  #geom_raster(aes(fill=llh))+
  scale_fill_continuous(high='black',low='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))+
  theme(axis.text=element_blank(),
        axis.title=element_blank(),
        axis.ticks=element_blank())+
  facet_wrap(~fix,ncol=3)


#   
# 
# 
#   pal.1=colorRampPalette(c("black", "red", "yellow","white"), space="rgb")
#    pal.2=colorRampPalette(c("black","black"), space="rgb")
#    jet.colors <-
#      colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
#                         "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
# 
# 
# data$llh=1
# data$x=((data$x-1)/(x_width-1))*2-1
# data$y=(((data$y-1)/(y_height-1))*2-1)*0.75
# # 
# data = data[1:fixnum,]
# data$fix=c(1:fixnum)
# data$shape='S'
# 
# data2<-data.frame(participant=1,
#                   image=25,
#                   index=1,
#                   fix.start=1,
#                   fix.end=1,
#                   x=c(data$x[2:6],NA),
#                   y=c(data$y[2:6],NA),
#                   llh=1,
#                   fix=1:6,
#                   shape='E')
# 
# datax<-rbind(data,data2)
# 
# datax<-datax[order(datax$fix),]
# 
# ggplot(saccadesALL,aes(x=x2,y=y2,z=llh*(-1),fill=llh*(-1)))+
#   geom_raster()+
#   
#   scale_fill_gradientn(colours=pal.1(7))+
#   scale_color_gradientn(colours=pal.2(7))+
#   stat_contour( data = saccadesALL, aes( x = x2, y = y2, z = llh*(-1),colour=..level..))+
#   
#   theme(legend.position='none')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))+
#   theme(axis.text=element_blank(),
#         axis.title=element_blank(),
#         axis.ticks=element_blank())+
#   geom_line(data=datax,aes(x=x,y=y))+
#   geom_point(data=datax,aes(x=x,y=y,shape=shape),size=4,colour='black')+
#   scale_shape_manual(values=c(16,1))+
#   facet_wrap(~fix)
# 
# direct.label(g1)
# 
# 

#   

setwd(mattwd)
