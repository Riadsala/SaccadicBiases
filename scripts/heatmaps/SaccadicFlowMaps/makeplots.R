rm(list = ls())

source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")

x_width=1024
y_height=720

d1<-read.csv('CNG_CG_S1.xls',header=T,sep='\t')
d2<-read.csv('CNG_CG_S2.xls',header=T,sep='\t')
d3<-read.csv('ENG_CG_S1.xls',header=T,sep='\t')
d4<-read.csv('ENG_CG_S2.xls',header=T,sep='\t')
d5<-read.csv('Gamers_CG.xls',header=T,sep='\t')

data=rbind(d1,d2,d3,d4,d5)

data<-subset(data,CURRENT_FIX_INDEX!=1)

data<-subset(data,image=='Image1A.jpg')

##make duration weight
data$dur=data$CURRENT_FIX_DURATION/max(data$CURRENT_FIX_DURATION)

##make cent weight
mu = c(0,0)
sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))

fixs.x=(round(c(data$CURRENT_FIX_X))/(x_width)*2)-1
fixs.y=(round(c(data$CURRENT_FIX_Y))/(x_width)*2)-1
fixs=cbind(fixs.x,fixs.y)

llh = dmvnorm(fixs, mu, sigma)

centweights=c(1-llh)

drawfixmap(x = data$CURRENT_FIX_X,y=data$CURRENT_FIX_Y,x_width=1024,y_height=720,plot=T,weight = 1)->reg.map

drawfixmap(x = data$CURRENT_FIX_X,y=data$CURRENT_FIX_Y,x_width=1024,y_height=720,plot=T,weight = 'dur',weights=data$dur)->dur.map

drawfixmap(x = data$CURRENT_FIX_X,y=data$CURRENT_FIX_Y,weights=centweights,weight='cent',x_width=1024,y_height=720,plot=T)->cent.map

jet.colors <-
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
g1<-ggplot(reg.map, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Fixation map')+
  scale_fill_gradientn(colours = jet.colors(10))+
  scale_colour_gradientn(colours = jet.colors(10))+
  #scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))

g2<-ggplot(dur.map, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Duration weighted map')+
  scale_fill_gradientn(colours = jet.colors(10))+
  scale_colour_gradientn(colours = jet.colors(10))+
  #scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))

g3<-ggplot(cent.map, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Central weighted map')+
  scale_fill_gradientn(colours = jet.colors(10))+
  scale_colour_gradientn(colours = jet.colors(10))+
  #scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))

multiplot(g1,g2,g3,cols=3)







