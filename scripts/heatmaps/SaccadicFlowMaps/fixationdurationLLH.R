rm(list = ls())

library(mvtnorm)
library(dplyr)
source('drawfixmap.R')
source("http://peterhaschke.com/Code/multiplot.R")

x_width=800
y_height=600

alldata=c()
# d1<-read.csv('Data/CNG_CG_S1.xls',header=T,sep='\t')
# d2<-read.csv('Data/CNG_CG_S2.xls',header=T,sep='\t')
# d3<-read.csv('Data/ENG_CG_S1.xls',header=T,sep='\t')
# d4<-read.csv('Data/ENG_CG_S2.xls',header=T,sep='\t')
# d5<-read.csv('Data/Gamers_CG.xls',header=T,sep='\t')
# 
# data=rbind(d1,d2,d3,d4,d5)

data=read.table(file='Data/ProcessedFixations.txt',header=F,sep=',')
colnames(data)<-c('participant','image','index','fix.start','fix.end','x','y')


data$duration<-data$fix.end-data$fix.start

# for (px in 1:max(data$participant)){
# data.sub<-subset(data,participant==px)
#   
# 
# for (sx in 1:max(data.sub$image)){
#   
#   data.sub2<-subset(data.sub,image==sx)
  
  ##make cent weight
  mu = c(0,0)
  sigma = array(c(0.22,0,0,0.45*0.22), dim=c(2,2))
  
  fixs.x=(round(c(data$x))/(x_width)*2)-1
  fixs.y=(round(c(data$y))/(x_width)*2)-1
  fixs=cbind(fixs.x,fixs.y)
  
  llh = dmvnorm(fixs, mu, sigma)
  
  centweights=c(1-llh)
  data$central=centweights  
  
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
  
saccades=data.frame(x1=data$x[2:(nrow(data))],
                    x2=data$x[1:(nrow(data)-1)],
                    y1=data$y[2:(nrow(data))],
                    y2=data$y[1:(nrow(data)-1)])
  
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
  
data$llh<-c(NA,llh)

refs<-which(is.na(data$llh))
datax<-data[-refs,]

datax<-subset(datax,llh!='-Inf')

ggplot(datax,aes(llh,duration))+geom_point()+geom_smooth(method='lm')


library(lme4)
m1<-lmer(duration~llh+(1+llh|participant)+(1+llh|image)+(1+llh|index),data=datax)


