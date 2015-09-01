
library(png)
library(grid)




source('fixmap.R')
source('gaussmap.R')
source("http://peterhaschke.com/Code/multiplot.R")


mypng <- readPNG('Image1.png')
bg <- rasterGrob(mypng, interpolate=TRUE)
# dumdat<-data.frame(x=1,y=1)
# 
# p<-ggplot(data=dumdat,aes(x=x,y=y)) + theme_bw()
# p <-p + annotation_custom(bg, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)+
#   ggtitle('Original image')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))
# 
# 
# fixmap1<-ggplot(fixmap, aes(x = Var2, y = Var1, fill = value2)) +
#   labs(x = "x", y = "y", fill = "density") +
#   geom_raster() +
#   theme_bw(20)+
#   ggtitle('original fixation map')+
#   scale_fill_continuous(low='black',high='white')+
#   theme(legend.position='none')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))
# 
# gauss1<-ggplot(gaussmap, aes(x = Var2, y = Var1, fill = value2)) +
#   labs(x = "x", y = "y", fill = "density") +
#   geom_raster() +
#   theme_bw(20)+
#   ggtitle('central bias generated map')+
#   scale_fill_continuous(low='black',high='white')+
#   theme(legend.position='none')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))
# 
# ##now make plot that multiplies the inverse of these

gaussmap$value3<-1-gaussmap$value2

fixmap$value3<-fixmap$value2*gaussmap$value3

# gauss2<-ggplot(fixmap, aes(x = Var2, y = Var1, fill = value3)) +
#   labs(x = "x", y = "y", fill = "density") +
#   geom_raster() +
#   theme_bw(20)+
#   ggtitle('central bias adjusted fixation map')+
#   scale_fill_continuous(low='black',high='white')+
#   theme(legend.position='none')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))


# multiplot(p,fixmap1,gauss1,gauss2,cols=2)

mypng[,,1]->r
mypng[,,2]->g
mypng[,,3]->b
mypng[,,4]->l

r<-melt(r)
g<-melt(g)
b<-melt(b)



r$newvals<-(r$value+g$value+b$value)/3

r$Var1<-721-r$Var1


fixmap2<-merge(fixmap,r,by=c('Var1','Var2'))
fixmap2$adjusted=fixmap2$newvals*fixmap2$value3
fixmap2$fixs=fixmap2$newvals*fixmap2$value2

jet.colors <-
  colorRampPalette(c("#00007F","#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

g1<-ggplot(fixmap2, aes(x = Var2, y = Var1, fill = newvals)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Original image')+

 scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))


g3<-ggplot(fixmap2, aes(x = Var2, y = Var1, fill = value3)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Cent bias adjusted map')+
  scale_fill_gradientn(colours = jet.colors(10))+
  scale_colour_gradientn(colours = jet.colors(10))+
  #scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))



g2<-ggplot(fixmap2, aes(x = Var2, y = Var1, fill = value2)) +
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





g4<-ggplot(gaussmap, aes(x = Var2, y = Var1, fill = value3)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Bias multiplier')+
  scale_fill_gradientn(colours = jet.colors(10))+
  scale_colour_gradientn(colours = jet.colors(10))+
  #scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))





g5<-ggplot(fixmap2, aes(x = Var2, y = Var1, fill = adjusted)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Cent bias adjusted map')+
  #scale_fill_gradientn(colours = jet.colors(10))+
  #scale_colour_gradientn(colours = jet.colors(10))+
  scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))



g6<-ggplot(fixmap2, aes(x = Var2, y = Var1, fill = fixs)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Fixation map')+
  #scale_fill_gradientn(colours = jet.colors(10))+
  #scale_colour_gradientn(colours = jet.colors(10))+
  scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))





multiplot(g1,g4,g6,g2,g5,g3,cols=3)


