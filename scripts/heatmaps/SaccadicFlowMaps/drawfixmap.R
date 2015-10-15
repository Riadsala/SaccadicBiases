##this code can be used to draw gaussian heatmap plots of fixation data

drawfixmap=function(x,
                    y,
                    weight=1,
                    weights=1,
                    x_width=1024,
                    y_height=720,
                    plot=F,
                    reshape=T,
                    pix_per_degree=100){

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
gaussian=makegaussian(pix_per_degree = pix_per_degree)
####OK now go through fixations and add a gaussian at each


multip=1
for (f in 1:nrow(df)){
  xpos=df$x[f]
  ypos=df$y[f]
  
  weightx=1
  if (weights[1]!=1){weightx=weights[f]}
  
  
  if (xpos>0 && xpos<x_width && ypos>0 && ypos<y_height){
    xmin=xpos-(pix_per_degree/2)
    ymin=ypos-(pix_per_degree/2)
    xmax=xpos+(pix_per_degree/2)-1
    ymax=ypos+(pix_per_degree/2)-1
    
    
    if (weight=='cent'){    
      xpos=(round(c(xpos))/(x_width)*2)-1
      ypos=((round(c(ypos))/(y_height)*2)-1)*0.75
                            fix=(c(xpos,ypos))
    
                            llh = dmvnorm(fix, mu, sigma)
                            multip=1.078428-llh}
    
    if (weight=='dur'){ multip=weightx}

    
        gaussadd<-gaussian
     #   print(paste(ymin,ymax,xmin,xmax,ncol(gaussadd),nrow(gaussadd),sep='_'))
    

    if (ymin<1){
      yrev=(-1)*ymin
      gaussadd<-gaussadd[(yrev+2):nrow(gaussadd),]
      
      ymin=1}
    
    if (xmin<1){
      xrev=(-1)*xmin
      gaussadd<-gaussadd[,(xrev+2):ncol(gaussadd)]
     xmin=1}
    
    if (ymax>y_height-1){
      yrev=nrow(gaussadd)-(-1)*(y_height-ymax)
      gaussadd<-gaussadd[1:yrev,]
      ymax=y_height}
        
    if (xmax>x_width-1){
      xrev=ncol(gaussadd)-(-1)*(x_width-xmax)
      gaussadd<-gaussadd[,1:xrev]
      
    xmax=x_width}
    #print(image(gaussadd))
   
    
    blank_image[ymin:ymax,xmin:xmax]<-blank_image[ymin:ymax,xmin:xmax]+(gaussadd*multip)
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
fixmap$value2<-fixmap$value/sum(fixmap$value)

#beep(2)

if (reshape == T){return(fixmap)}
if (reshape == F){return(z)}


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


