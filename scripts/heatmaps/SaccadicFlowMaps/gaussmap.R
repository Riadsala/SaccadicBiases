
##this code can be used to draw gaussian heatmap plots of fixation data
#rm(list = ls())


require(ggplot2)
require(reshape2)
library(MASS)


#sampnum=nrow(data)
sampnum=10000

##generate cent bias
Sigma <- matrix(c(0.22,0,0,0.11),2,2)
test=mvrnorm(n = sampnum, rep(0, 2), Sigma)


##note start time
#start_time = format(Sys.time(), "%H:%M:%S")
ptm <- proc.time()
##code to update for each data set

data<-data.frame(test)
colnames(data)<-c('x','y')

data$x<-(data$x+1)*(1024/2)
data$y<-(data$y+1)*(720/2)

x_width=1024
y_height=720
pix_per_degree=100

##generate random fixs
#x=rnorm(100000,mean=0.5,sd=0.4)*x_width
#y=rnorm(100000,mean=0.5,sd=0.2)*y_height
#thisdata<-subset(CP,CURRENT_FIX_INDEX!=1)
x=data$x
y=y_height-data$y


x<-round(x)
y<-round(y)
##combine into data frame
df = data.frame(cbind(x,y))
df = subset(df,x>0)
df = subset(df,x<x_width)
df = subset(df,y>0)
df = subset(df,y<y_height)
##generate blank matrix
blank_image<-matrix(0,y_height,x_width)


#####MAKE GAUSSIAN
source('makegaussian.R')
gaussian=makegaussian(pix_per_degree = 100)
####OK now go through fixations and add a gaussian at each

for (f in 1:nrow(df)){
  xpos=df$x[f]
  ypos=df$y[f]
  
  if (xpos>(pix_per_degree/2) && xpos<x_width-(pix_per_degree/2) && ypos>(pix_per_degree/2) && ypos<y_height-(pix_per_degree/2)){
    xmin=xpos-(pix_per_degree/2)
    ymin=ypos-(pix_per_degree/2)
    xmax=xpos+(pix_per_degree/2)-1
    ymax=ypos+(pix_per_degree/2)-1
    
    blank_image[ymin:ymax,xmin:xmax]<-blank_image[ymin:ymax,xmin:xmax]+gaussian
    ##if error - uncomment print(f) to find the 'problem' data
    # print(f)
  }
  
  ##do something special if on edge of screen
}
##note start time
#image_time = format(Sys.time(), "%M:%S")

make_image_time<-proc.time() - ptm
made_image<-proc.time()
z<-blank_image 

#image(z,col=gray.colors(12, start = 0.1, end = 0.9, gamma = 2.2, alpha = NULL))

##use ggplot - looks nicer, takes longer!

gaussmap <- melt(z)
gaussmap$value2<-gaussmap$value/max(gaussmap$value)


# 
# 
# 
# 
# ##RIGHT, NOW MAKE GAUSSIAN SAME SIZE AS SCREEN
# gaussian2=makegaussian(1024)
# 
# 
# library(raster)
# #m <- matrix(seq_len(68*128), nrow=68, ncol=128, byrow=TRUE)
# 
# ## Convert matrix to a raster with geographical coordinates
# r <- raster(gaussian2)
# extent(r) <- extent(c(-180, 180, -90, 90))
# 
# ## Create a raster with the desired dimensions, and resample into it
# s <- raster(nrow=720, ncol=1024)
# s <- resample(r,s)
# 
# ## Convert resampled raster back to a matrix
# m2 <- as.matrix(s)
# 
# 
# 
# 
# gauss<-melt(m2)
# ##reverse scales
# #gauss$value=gauss$value+0.05
# #gauss$value=gauss$value/sum(gauss$value)
# gauss$valueLog=-log(gauss$value)
# gauss$value=1-gauss$value
# #gauss$value=1-gauss$value
# #gauss$value=gauss$value/max(gauss$value)
# 
# #gauss$value=gauss$value-min(gauss$value)
# 
# #gauss$value[gauss$value==Inf]<-median(gauss$value[gauss$value!=Inf])
# # 
# 
# g2L<-ggplot(gauss, aes(x = Var2, y = Var1, fill = valueLog)) +
#   labs(x = "x", y = "y", fill = "density") +
#   geom_raster() +
#   theme_bw(20)+
#   ggtitle('gaussian multiplier (Log)')+
#   theme(legend.position='none')+
#   scale_fill_continuous(low='black',high='white')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))
# 
# # g2<-ggplot(gauss, aes(x = Var2, y = Var1, fill = value)) +
# #   labs(x = "x", y = "y", fill = "density") +
# #   geom_raster() +
# #   theme_bw(20)+
# #   ggtitle('gaussian multiplier')+
# #   theme(legend.position='none')+
# #   scale_fill_continuous(low='black',high='white')+
# #   scale_x_continuous(expand = c(0, 0)) +
# #   scale_y_continuous(expand = c(0, 0))
# # 
# 
# ##use to multiply
# ##make maximum of 1
# summer=0.05
# 
# # require(manipulate)
# # manipulate({
# gauss$value2=gauss$valueLog+summer
# 
# citymap$value3<-citymap$value2*gauss$value2
# 
# #citymap$value3L<-citymap$value2*gauss$valueLog
# 
# ggplot(citymap, aes(x = Var2, y = Var1, fill = value3)) +
#   labs(x = "x", y = "y", fill = "density") +
#   geom_raster() +
#   ggtitle('cent bias adjusted fix map')+
#   theme_bw(20)+
#   theme(legend.position='none')+
#   scale_fill_continuous(low='black',high='white')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))

# },
# summer=slider(0,1,initial=0.05,step=0.05)
# )



# g3L<-ggplot(citymap, aes(x = Var2, y = Var1, fill = value3L)) +
#   labs(x = "x", y = "y", fill = "density") +
#   geom_raster() +
#   ggtitle('cent bias (-Log) adjusted fix map')+
#   theme_bw(20)+
#   theme(legend.position='none')+
#   scale_fill_continuous(low='black',high='white')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))
