source('fixmap.R')
source('gaussmap.R')
source("http://peterhaschke.com/Code/multiplot.R")

fixmap<-ggplot(fixmap, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('original fixation map')+
  scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))

gauss1<-ggplot(gaussmap, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('central bias generated map')+
  scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))

##now make plot that multiplies the inverse of these


fixmap$value3<-fixmap$value2*(1-gaussmap$value2)

gauss2<-ggplot(fixmap, aes(x = Var2, y = Var1, fill = value3)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('central bias adjusted fixation map')+
  scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))


multiplot(fixmap,gauss1,gauss2)
