function [Sig Nu Loglik] = FitGaussPerFixN(allfix, N, Sig2, fixmode)

Sig = NaN .* ones(1,19);
Nu =  NaN .* ones(1,19);
Loglik =  NaN .* ones(1,19);

for f = 2:20
    if strcmp(fixmode, 'equal')
        fix = allfix(allfix(:,2)==f, :);
    elseif strcmp(fixmode, 'leq')
        fix = allfix(allfix(:,2)<=f, :);
    end
    
    M = length(fix);
    if M>25
        [sig2, nu loglik] = FitGaussianForCentralBias(fix, 0.75, Sig2);
        fnu = nu;
        fsig = sig2;
    end
    
    Sig(f-1) = nanmean(fsig);
    Nu(f-1) = nanmean(fnu);
    Loglik(f-1) = nanmean(loglik);
end
clear fix
end

