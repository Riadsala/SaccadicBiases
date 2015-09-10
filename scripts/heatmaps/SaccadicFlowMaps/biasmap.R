library(mvtnorm)
library(dplyr)
library(ggplot2)

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

saccades=data.frame(x1=data$CURRENT_FIX_X[1:(nrow(data)-1)],
                x2=data$CURRENT_FIX_X[2:(nrow(data))],
                y1=data$CURRENT_FIX_X[1:(nrow(data)-1)],
                y2=data$CURRENT_FIX_X[2:(nrow(data))])

saccades=((saccades/1024)*2)-1


biasParams = read.csv(paste('ALL_flowModels_0.1.txt', sep=''))

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


data$llh=c(llh,NA)
refs<-which(data$CURRENT_FIX_INDEX==2)
refs=refs-1
refs=refs[2:length(refs)]

datax=data[-refs,]
datax=datax[1:nrow(datax)-1,]
datax$llh<-sqrt(datax$llh^2)

datax$llh<-datax$llh/max(datax$llh)
drawfixmap(x = datax$CURRENT_FIX_X,y=datax$CURRENT_FIX_Y,weights=datax$llh,weight='dur',x_width=1024,y_height=720,plot=T)->bias.map


g4<-ggplot(bias.map, aes(x = Var2, y = Var1, fill = value2)) +
  labs(x = "x", y = "y", fill = "density") +
  geom_raster() +
  theme_bw(20)+
  ggtitle('Bias weighted map')+
  scale_fill_gradientn(colours = jet.colors(10))+
  scale_colour_gradientn(colours = jet.colors(10))+
  #scale_fill_continuous(low='black',high='white')+
  theme(legend.position='none')+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))