
##draw behavioural bias heatmaps

rm(list = ls())

library(mvtnorm)
library(dplyr)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")

##set width and height of data
x_width=800
y_height=600


data=read.table(file='Data/ProcessedFixations.txt',header=F,sep=',')
colnames(data)<-c('participant','image','index','fix.start','fix.end','x','y')



data<-subset(data,x>0 & x<800 & y<600 & y>0)
data$xcol=3
data$xcol[data$x<((800/3)*2)]<-2
data$xcol[data$x<(800/3)]<-1
data$ycol=3
data$ycol[data$y<((600/3)*2)]<-2
data$ycol[data$y<(600/3)]<-1
data$patch=paste0(data$ycol,data$xcol)

data$nextx=c(data$x[2:nrow(data)],NA)
data$nexty=c(data$y[2:nrow(data)],NA)

which(data$index==1)->refs
refs<-refs-1
data<-data[-refs,]
data<-data[-nrow(data),]

for (dx in unique(data$patch)){

  data.sub<-subset(data,patch==dx)
  drawfixmap(x = data.sub$nextx,y=data.sub$nexty,x_width=800,y_height=600,plot=F,weight = 1)->reg.map

  pal.1=colorRampPalette(c("black", "red", "yellow","white"), space="rgb")
  
  
  g1<-ggplot(reg.map, aes(x = Var2, y = Var1, fill = value2)) +
    labs(x = "x", y = "y", fill = "density") +
    geom_raster() +
    theme_bw(20)+
    # ggtitle('Fixation map')+
    scale_fill_gradientn(colours=pal.1(12))+
    #   scale_fill_gradientn(colours = jet.colors(10))+
    #   scale_colour_gradientn(colours = jet.colors(10))+
    #scale_fill_continuous(low='black',high='white')+
    theme(legend.position='none')+
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0))+
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank())
  
  savename=paste('BBias_', dx, '.pdf',sep='')
  ggsave(filename = savename,plot = g1, path = 'Figures',width = 8,height=6,unit='in')

}
