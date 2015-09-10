##this code can be used to draw gaussian heatmap plots of fixation data
#rm(list = ls())


require(ggplot2)
require(reshape2)
require(mvtnorm)
##note start time
#start_time = format(Sys.time(), "%H:%M:%S")
ptm <- proc.time()
##code to update for each data set
# 

dset='asher'
testx=c()

d1<-read.csv('CNG_CG_S1.xls',header=T,sep='\t')
d2<-read.csv('CNG_CG_S2.xls',header=T,sep='\t')
d3<-read.csv('ENG_CG_S1.xls',header=T,sep='\t')
d4<-read.csv('ENG_CG_S2.xls',header=T,sep='\t')
d5<-read.csv('Gamers_CG.xls',header=T,sep='\t')

data=rbind(d1,d2,d3,d4,d5)

data<-subset(data,CURRENT_FIX_INDEX!=1)
data<-data.frame(scene=data$image,
                 x=data$CURRENT_FIX_X,
                 y=data$CURRENT_FIX_Y,
                 dur=data$CURRENT_FIX_DURATION/max(data$CURRENT_FIX_DURATION))



# 
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

data<-subset(data,scene=='Image1A.jpg')

x_width=1024
y_height=720
pix_per_degree=100

mu = c(0,0)
sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))


##generate random fixs
#x=rnorm(100000,mean=0.5,sd=0.4)*x_width
#y=rnorm(100000,mean=0.5,sd=0.2)*y_height
#thisdata<-subset(CP,CURRENT_FIX_INDEX!=1)


x=data$x
y=y_height-data$y


# 
# #####TO TEST IF IT KILLS IT!!!!!!
#  test2<-((test+1)/2)*1024
#  x=data.frame(test2[,1])
#  y=data.frame(test2[,1])

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
    
    fix=(c(xpos,ypos)/(x_width)*2)-1
    llh = dmvnorm(fix, mu, sigma)
    testx<-c(testx,llh)
      
      blank_image[ymin:ymax,xmin:xmax]<-blank_image[ymin:ymax,xmin:xmax]+(gaussian*(1-llh))
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

centmap <- melt(z)
centmap$value2<-centmap$value/max(centmap$value)
# # 
ggplot(centmap, aes(x = Var2, y = Var1, fill = value2)) +
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



