makegaussian<-function(pix_per_degree=48){

imSize = pix_per_degree                           # image size: n X n
sigma = imSize/6                     #gaussian standard deviation in pixels
phase = 0.5                           # phase (0 -> 1)
trim = .005   

X = 1:imSize                          # X is a vector from 1 to imageSize
X0 = (X / imSize) - .5
s=sigma/imSize  #gaussian width as fraction of imageSize
Xg<-exp(-((X0^2) ) / (2*(s^2)))

meshgrid <- function(a,b) {
  list(
    x=outer(b*0,a,FUN="+"),
    y=outer(b,a*0,FUN="+")
  )
} 

bob<-meshgrid(X0,X0)

Xm<-bob[[1]]
Ym<-bob[[2]]


gauss<-exp( -(((Xm^2)+(Ym^2))/(2*(s^2))))


#trim
#gauss[gauss<trim]<-0
require(ggplot2)
require(reshape2)
# plotim<-melt(gauss)
# gg<-ggplot(plotim, aes(x = Var2, y = Var1, fill = value)) +
#   labs(x = "x", y = "y", fill = "density") +
#   geom_raster() +
#   theme_bw(20)+
#   scale_fill_continuous(low='black',high='white')+
#   theme(legend.position='none')+
#   scale_x_continuous(expand = c(0, 0)) +
#   scale_y_continuous(expand = c(0, 0))
# print(gg)

return(gauss)
}
