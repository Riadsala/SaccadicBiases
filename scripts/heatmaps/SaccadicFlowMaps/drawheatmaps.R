rm(list = ls())

library(mvtnorm)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")

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
fixs.y=(round(c(data.sub$y))/(x_width)*2)-1
fixs=cbind(fixs.x,fixs.y)

llh = dmvnorm(fixs, mu, sigma)

centweights=c(1-llh)


##make saccadic bias weight

calcNormLLH <- function(sacc, v)
{
  fix = cbind(sacc$x2, sacc$y2)
  
  mu = c(v['mu_x'], v['mu_y'])
  sigma = array(c(v['sigma_xx'], v['sigma_xy'], v['sigma_xy'], v['sigma_yy']), dim=c(2,2))
  
  llh = log(dmvnorm(fix, mu, sigma))
  return(llh)
}
calcSkewNormalLLH <- function(sacc, v)
{    
  fix = cbind(sacc$x2, sacc$y2)
  # dmsn(x, xi=rep(0,length(alpha)), Omega, alpha, tau=0, dp=NULL, log=FALSE)
  xi = c(v['xi_x'], v['xi_y'])
  Omega = array(c(v['Omega-xx'],v['Omega-xy'],v['Omega-xy'],v['Omega-yy']), dim=c(2,2))
  alpha = c(v['alpha-x2'], v['alpha-y2'])
  
  llh = dmsn(fix, dp=list(xi=xi, Omega=Omega, alpha=alpha),log=T)
}

getParamPoly <- function(sacc)
{   
  v = c(1, 
        sacc$x1, sacc$x1^2, sacc$x1^3, sacc$x1^4, 
        sacc$y1, sacc$y1^2, sacc$y1^3, sacc$y1^4)
  return(v)
}

saccades=data.frame(x1=data.sub$x[1:(nrow(data.sub)-1)],
                    x2=data.sub$x[2:(nrow(data.sub))],
                    y1=data.sub$y[1:(nrow(data.sub)-1)],
                    y2=data.sub$y[2:(nrow(data.sub))])

saccades=((saccades/x_width)*2)-1


biasParams = read.csv(paste('Models/ALL_flowModels_0.1.txt', sep=''))

flowParams = filter(biasParams, biasModel=='N')
flow='N'
parameters = unique(flowParams$feat)
llh = rep(0, nrow(saccades))

for (ii in 1:nrow(saccades))
{
  saccade = saccades[ii,]
  
  valuesForDist = rep(0, length(parameters))
  names(valuesForDist) = parameters
  
  v = getParamPoly(saccade)
  
  for (jj in 1:length(parameters))
  {
    parameter = parameters[jj]
    polyCoefs = filter(flowParams, feat==parameters[jj])$coef
    valuesForDist[as.character(parameter)] = v %*% polyCoefs
  }
  
  if (flow=='N') {
    llh[ii] = calcNormLLH(saccade, valuesForDist) 
  }
  else if (flow=='SN') {
    llh[ii] = calcSkewNormalLLH(saccade, valuesForDist)
  } 
}


data.sub$llh=c(llh,NA)
refs<-which(data.sub$index==2)
refs=refs-1
refs=refs[2:length(refs)]

datax=data.sub[-refs,]
datax=datax[1:nrow(datax)-1,]
datax$llh<-sqrt(datax$llh^2)

datax<-datax[datax$llh!='Inf',]
datax<-datax[datax$llh!='NaN',]
datax$llh<-datax$llh





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
r$Var1<-y_height-r$Var1

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
ggsave(filename = savename,plot = g0, path = 'Heatmaps',width = 8,height=6,unit='in')











pal.1=colorRampPalette(c("black", "red", "yellow","white"), space="rgb")

jet.colors <-
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

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

savename=paste('Im', im, '_1.pdf',sep='')
ggsave(filename = savename,plot = g1, path = 'Heatmaps',width = 8,height=6,unit='in')

g2<-ggplot(dur.map, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
 # ggtitle('Duration weighted map')+
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

savename=paste('Im', im, '_2.pdf',sep='')
ggsave(filename = savename,plot = g2, path = 'Heatmaps',width = 8,height=6,unit='in')

g3<-ggplot(cent.map, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
 # ggtitle('Central weighted map')+
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

savename=paste('Im', im, '_3.pdf',sep='')
ggsave(filename = savename,plot = g3, path = 'Heatmaps',width = 8,height=6,unit='in')


g4<-ggplot(bias.map, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  #ggtitle('Bias weighted map')+
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

savename=paste('Im', im, '_4.pdf',sep='')
ggsave(filename = savename,plot = g4, path = 'Heatmaps',width = 8,height=6,unit='in')

}







