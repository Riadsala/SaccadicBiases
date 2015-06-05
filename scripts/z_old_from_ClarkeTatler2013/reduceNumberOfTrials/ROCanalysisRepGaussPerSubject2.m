function [AUCfit AUCbl] = ROCanalysisRepGaussPerSubject2(perSubj, bl)

%% we're Bootstrapping, so randomly sample F
% list of alpha values we want to explore
% does everything several times so we can have error bars




for s = 1:length(perSubj)
    
    nfix = size(perSubj(s).testfix,1);
    if nfix > 0 
    size(perSubj(s).testfix)
    C = [ones(nfix,1); zeros(nfix,1)];
    
    fixX = perSubj(s).testfix(:,4);
    fixY = perSubj(s).testfix(:,5);
    
    uniX = perSubj(s).testfix(:,6);
    uniY = perSubj(s).testfix(:,7);
    
    nu = perSubj(s).nu;
    sigma = perSubj(s).sig2;
    
    
    F = [fixX, fixY; uniX, uniY];
   
        if isfinite(sigma) * (nu>0)
            [sigma, 0; 0, nu*sigma]
            D =  mvnpdf(F, [0 0], [sigma, 0; 0, nu*sigma]);            
            b = glmfit(D, C, 'binomial');            
            yfit = glmval(b, D, 'logit');
            [~,~,~,auc] = perfcurve(C,yfit,1);
            AUCfit(s) = auc;
        else
            AUCfit(s) = NaN;
        end
        
        D =  mvnpdf(F, [0 0], [bl(1), 0; 0, bl(2)*bl(1)]);
        size(D)
        size(C)
        
        try
            b = glmfit(D, C, 'binomial');
        catch
            disp('<')
        end
        yfit = glmval(b, D, 'logit');
        [~,~,~,auc] = perfcurve(C,yfit,1);
        AUCbl(s) = auc;
    else
        AUCbl(s) = NaN;
        AUCfit(s) = NaN;
    end
    clear fixX fixY D C F uniX uniY nfix
end

