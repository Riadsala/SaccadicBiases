rm(list = ls())

library(mvtnorm)
library(sn)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")
library(dplyr)
x_width=30
y_height=20
xposn=3
yposn=3


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

saccades=data.frame(x1=xposn,
                    x2=rep(1:x_width,each=y_height),
                    y1=yposn,
                    y2=rep(1:y_height,x_width))

saccades=((saccades/x_width)*2)-1


biasParams = read.csv(paste('Models/ALL_flowModels_0.1.txt', sep=''))

flow='N'
flowParams = filter(biasParams, biasModel==flow)
parameters = unique(flowParams$feat)
llh = rep(0, nrow(saccades))


for (ii in 1:nrow(saccades))
{
  print(ii)
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
   # print(llh[ii])
  }
  else if (flow=='SN') {
    llh[ii] = calcSkewNormalLLH(saccade, valuesForDist)
  } 
}

saccades$llh<-llh*(-1)
library(ggplot2)
ggplot(saccades,aes(x=x2,y=y2,fill=llh))+
  geom_raster()+
  geom_point(aes(x=x1,y=y1))  +
  scale_fill_continuous(low='white',high='black')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))+
  theme(axis.text=element_blank(),
        axis.title=element_blank(),
        axis.ticks=element_blank())
  
  