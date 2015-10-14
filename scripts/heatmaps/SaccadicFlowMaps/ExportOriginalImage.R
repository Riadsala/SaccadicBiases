rm(list = ls())

library(mvtnorm)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")
library(matrixcalc)
library(plyr)
x_width=800
y_height=600


##this is a bit of a fudge as I don't know how to reference relative file sources
#setwd("/Users/matthewstainer/Documents/Work/Papers/SaccadicBiases/scripts/heatmaps/SaccadicFlowMaps")
getwd()->mattwd
setwd("../../../../SaccadicBiases/scripts/flow/")
source('flowDistFunctions.R')
alwd<-getwd()
setwd(mattwd)
# d1<-read.csv('Data/CNG_CG_S1.xls',header=T,sep='\t')
# d2<-read.csv('Data/CNG_CG_S2.xls',header=T,sep='\t')
# d3<-read.csv('Data/ENG_CG_S1.xls',header=T,sep='\t')
# d4<-read.csv('Data/ENG_CG_S2.xls',header=T,sep='\t')
# d5<-read.csv('Data/Gamers_CG.xls',header=T,sep='\t')
# 
# data=rbind(d1,d2,d3,d4,d5)

data=read.table(file='Data/ProcessedFixations.txt',header=F,sep=',')
colnames(data)<-c('participant','image','index','fix.start','fix.end','x','y')

data<-subset(data,index!=1)
data$duration<-data$fix.end-data$fix.start

#imselect=c(12,13,10,38,53,50,70,73,78,79,89,100,92,93,99,88,54)
imselect=93
for (im in imselect){
  ##make images
  library(png)
  library(grid)
  ##read in image and convert to grayscale
  imagename=paste('Images/Image',im,'.png',sep='')
  mypng <- readPNG(imagename)
     mypng[,,1]->r
     mypng[,,2]->g
     mypng[,,3]->b
     r<-melt(r)
     g<-melt(g)
     b<-melt(b)
     r$newvals<-(r$value+g$value+b$value)/3
     
  
    r$Var1<-y_height-r$Var1
    
    g0<-ggplot(r, aes(x = Var2, y = Var1, fill = newvals)) +
      annotation_raster(mypng, -Inf, Inf, -Inf, Inf, interpolate = TRUE)+
      labs(x = "x", y = "y", fill = "density") +
      #geom_raster() +
      theme_bw(20)+
      #ggtitle('Original image')+
      
      scale_fill_continuous(low='black',high='white')+
      theme(legend.position='none')+
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0)) +
      theme(axis.text=element_blank(),
            axis.title=element_blank(),
            axis.ticks=element_blank())
    
    savename=paste('Im', im, '_0.png',sep='')
    ggsave(filename = savename,plot = g0, path = 'Heatmaps2',width = 8,height=6,unit='in')
  
}







