##this code can be used to draw gaussian heatmap plots of fixation data

drawfixmap=function(x,
                    y,
                    weight=1,
                    weights=1,
                    x_width=1024,
                    y_height=720,
                    plot=F){

require(ggplot2)
require(reshape2)
require(mvtnorm)
require(beepr)
# å
#   data=read.csv('MFA_FixationDataNOV_2013.csv',header=F)
#   
#    colnames(data)<-c('image','ptpt','index','x','y','del','del2')
# 
# 
# data<-subset(data,index!=1)
# 
# data<-data.frame(scene=data$image,
#                  x=data$x,
#                  y=data$y)
# 
# data<-subset(data,scene==30)
#colnames(data)<-c('scene','x','y')

#data<-subset(data,scene=='Image1A.jpg')


pix_per_degree=100

##generate random fixs
#x=rnorm(100000,mean=0.5,sd=0.4)*x_width
#y=rnorm(100000,mean=0.5,sd=0.2)*y_height
#thisdata<-subset(CP,CURRENT_FIX_INDEX!=1)
#x=data$x
y=y_height-y


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


multip=1
for (f in 1:nrow(df)){
  xpos=df$x[f]
  ypos=df$y[f]
  
  weightx=1
  if (weights[1]!=1){weightx=weights[f]}
  
  
  if (xpos>(pix_per_degree/2) && xpos<x_width-(pix_per_degree/2) && ypos>(pix_per_degree/2) && ypos<y_height-(pix_per_degree/2)){
    xmin=xpos-(pix_per_degree/2)
    ymin=ypos-(pix_per_degree/2)
    xmax=xpos+(pix_per_degree/2)-1
    ymax=ypos+(pix_per_degree/2)-1
    
    
    if (weight=='cent'){    fix=(c(xpos,ypos)/(x_width)*2)-1
                            llh = dmvnorm(fix, mu, sigma)
                            multip=1-llh}
    
    if (weight=='dur'){ multip=weightx}
    
    blank_image[ymin:ymax,xmin:xmax]<-blank_image[ymin:ymax,xmin:xmax]+(gaussian*multip)
    ##if error - uncomment print(f) to find the 'problem' data
    # print(f)
  }
}
  ##do something special if on edge of screen

##note start time
#image_time = format(Sys.time(), "%M:%S")

# make_image_time<-proc.time() - ptm
# made_image<-proc.time()
z<-blank_image 

#image(z,col=gray.colors(12, start = 0.1, end = 0.9, gamma = 2.2, alpha = NULL))

##use ggplot - looks nicer, takes longer!

fixmap <- melt(z)
fixmap$value2<-fixmap$value/max(fixmap$value)

beep(2)
return(fixmap)

# 
#plottrue=plotx

if (plot ==T){
  jet.colors <-
                 colorRampPalette(c("#00007F","#00007F", "blue", "#007FFF", "cyan",
                                    "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
  
g1<-ggplot(fixmap, aes(x = Var2, y = Var1, fill = value2)) +
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

print(g1)
}


}


