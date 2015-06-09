function AUC = ROCanalysisRepGauss(perSubj)

%% we're Bootstrapping, so randomly sample F
% list of alpha values we want to explore
% does everything several times so we can have error bars

AUC = zeros(1, length(perSubj));

perSubj

for s = 1:length(perSubj)
    
    nfix = length(perSubj(s).fix);
    C = [ones(nfix,1); zeros(nfix,1)];
    
    fixX = perSubj(s).fix(:,3);
    fixY = perSubj(s).fix(:,4);
    
    uniX = 2*(rand(nfix,1) - 0.5);
    uniY = 1.5*(rand(nfix,1) - 0.5);
    
    nu = perSubj(s).nu;
    sigma = perSubj(s).sig2;
    
    F = [fixX, fixY; uniX, uniY];
   
    D =  mvnpdf(F, [0 0], [sigma, 0; 0, nu*sigma]);
    b = glmfit(D, C, 'binomial');
    yfit = glmval(b, D, 'logit');
    [~,~,~,auc] = perfcurve(C,yfit,1);
    AUC(s) = auc;
end

