rm(list = ls())

library(mvtnorm)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")

##this is a bit of a fudge as I don't know how to reference relative file sources
setwd("/Users/matthewstainer/Documents/Work/Papers/SaccadicBiases/scripts/heatmaps/SaccadicFlowMaps")
getwd()->mattwd
setwd("/Users/matthewstainer/Documents/Work/Papers/SaccadicBiases/scripts/flow/")
source('flowDistFunctions.R')
alwd<-getwd()
setwd(mattwd)
x_width=800
y_height=600

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

#imselect=c(1,3,4,5,6,7,9,12)
imselect=3
for (im in imselect){
  imnum=im
  data.sub<-subset(data,image==imnum)
  
  ##make duration weight
  data.sub$dur=data.sub$duration/max(data.sub$duration)
  
  ##make cent weight
  mu = c(0,0)
  sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
  
  fixs.x=(round(c(data.sub$x))/(x_width)*2)-1
  fixs.y=(round(c(data.sub$y))/(x_width)*2)-1
  fixs=cbind(fixs.x,fixs.y)
  
  llh = dmvnorm(fixs, mu, sigma)
  
  centweights=c(1-llh)
  
  
  ##make saccadic bias weight
  
  saccades=data.frame(x1=data.sub$x[2:(nrow(data.sub))],
                      x2=data.sub$x[1:(nrow(data.sub)-1)],
                      y1=data.sub$y[2:(nrow(data.sub))],
                      y2=data.sub$y[1:(nrow(data.sub)-1)])
  
  
  
  
  
  # 
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
  
  data.sub$llh<-c(llh,NA)
  #data.sub$llh<-data.sub$llh + min(data.sub$llh,na.rm=T)
  
  
  refs<-which(data.sub$index==2)
  refs=refs-1
  refs=refs[2:length(refs)]
  
  datax=data.sub[-refs,]
  datax=datax[1:(nrow(datax)-1),]
  datax<-datax[datax$llh!='-Inf',]
  
  
  datax$llh=datax$llh+min(datax$llh)
  datax$llh<-sqrt(datax$llh^2)
  datax$llh<-datax$llh-min(datax$llh)
  datax$llh<-datax$llh/max(datax$llh)
  datax$llh
  
  
  
  
  
  drawfixmap(x = data.sub$x,y=data.sub$y,x_width=800,y_height=600,plot=F,weight = 1)->reg.map
  
  drawfixmap(x = data.sub$x,y=data.sub$y,x_width=800,y_height=600,plot=F,weight = 'dur',weights=data$dur)->dur.map
  
  drawfixmap(x = data.sub$x,y=data.sub$y,x_width=800,y_height=600,plot=F,weights=centweights,weight='cent')->cent.map
  
  drawfixmap(x = datax$x,y=datax$y,weights=datax$llh,weight='dur',x_width=800,y_height=600,plot=F)->bias.map
  
  
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
    r$Var1<-(y_height-r$Var1)+1
   r<- r[with(r, order(Var2, Var1)), ]
  
  #   
    g0<-ggplot(r, aes(x = Var2, y = Var1, fill = newvals)) +
      labs(x = "x", y = "y", fill = "density") +
      geom_raster() +
      theme_bw(20)+
      #ggtitle('Original image')+
      
      scale_fill_continuous(low='black',high='white')+
      theme(legend.position='none')+
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0)) +
      theme(axis.text=element_blank(),
            axis.title=element_blank(),
            axis.ticks=element_blank())
    
    savename=paste('Im', im, '_0.pdf',sep='')
    ggsave(filename = savename,plot = g0, path = 'Heatmaps3',width = 8,height=6,unit='in')
    
  #   
  
  
  
  
  
  
  
  
  
#   pal.1=colorRampPalette(c("black", "red", "yellow","white"), space="rgb")
#   
#   jet.colors <-
#     colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
#                        "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
  
   r$fixs<-r$newvals*reg.map$value2
  
  g1<-ggplot(r, aes(x = Var2, y = Var1, fill = fixs)) +
    labs(x = "x", y = "y", fill = "density") +
    #annotation_raster(mypng, -Inf, Inf, -Inf, Inf, interpolate = TRUE)+
    geom_raster() +
    theme_bw(20)+
    # ggtitle('Fixation map')+
    #scale_fill_gradientn(colours=pal.1(12))+
    #   scale_fill_gradientn(colours = jet.colors(10))+
    #   scale_colour_gradientn(colours = jet.colors(10))+
    #scale_fill_continuous(low='black',high='white')+
  scale_fill_continuous(low='black',high='white')+
    theme(legend.position='none')+
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0))+
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank())
  
  savename=paste('Im', im, '_1.pdf',sep='')
  ggsave(filename = savename,plot = g1, path = 'Heatmaps3',width = 8,height=6,unit='in')
  


r$dur<-r$newvals*dur.map$value2
  g2<-ggplot(r, aes(x = Var2, y = Var1, fill = dur)) +
    labs(x = "x", y = "y", fill = "density") +
   # annotation_raster(mypng, -Inf, Inf, -Inf, Inf, interpolate = TRUE)+
    geom_raster() +
    theme_bw(20)+
    # ggtitle('Duration weighted map')+
   # scale_fill_gradientn(colours=pal.1(12))+
    #   scale_fill_gradientn(colours = jet.colors(10))+
    #   scale_colour_gradientn(colours = jet.colors(10))+
    #scale_fill_continuous(low='black',high='white')+
  scale_fill_continuous(low='black',high='white')+
    theme(legend.position='none')+
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0))+
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank())
  
  savename=paste('Im', im, '_2.pdf',sep='')
  ggsave(filename = savename,plot = g2, path = 'Heatmaps3',width = 8,height=6,unit='in')
  
r$cent<-r$newvals*cent.map$value2
  g3<-ggplot(r, aes(x = Var2, y = Var1, fill = cent)) +
    labs(x = "x", y = "y", fill = "density") +
   # annotation_raster(mypng, -Inf, Inf, -Inf, Inf, interpolate = TRUE)+
    geom_raster() +
    theme_bw(20)+
    # ggtitle('Central weighted map')+
   # scale_fill_gradientn(colours=pal.1(12))+
    #   scale_fill_gradientn(colours = jet.colors(10))+
    #   scale_colour_gradientn(colours = jet.colors(10))+
    #scale_fill_continuous(low='black',high='white')+
  scale_fill_continuous(low='black',high='white')+
    theme(legend.position='none')+
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0))+
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank())
  
  savename=paste('Im', im, '_3.pdf',sep='')
  ggsave(filename = savename,plot = g3, path = 'Heatmaps3',width = 8,height=6,unit='in')
  
r$flow<-r$newvals*bias.map$value2
  g4<-ggplot(r, aes(x = Var2, y = Var1, fill = flow)) +
    labs(x = "x", y = "y", fill = "density") +
   ## annotation_raster(mypng, -Inf, Inf, -Inf, Inf, interpolate = TRUE)+
    geom_raster() +
    theme_bw(20)+
    #ggtitle('Bias weighted map')+
  #  scale_fill_gradientn(colours=pal.1(12))+
    #   scale_fill_gradientn(colours = jet.colors(10))+
    #   scale_colour_gradientn(colours = jet.colors(10))+
    #scale_fill_continuous(low='black',high='white')+
  scale_fill_continuous(low='black',high='white')+
    theme(legend.position='none')+
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0))+
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank())
  
  savename=paste('Im', im, '_4.pdf',sep='')
  ggsave(filename = savename,plot = g4, path = 'Heatmaps3',width = 8,height=6,unit='in')
  
}







