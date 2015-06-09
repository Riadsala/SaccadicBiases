function [AUC sig nu2test] = bootstrapAUC(fix, N, Sig2, asprat)

M = length(fix);
for n = 1:N
    z = randi(M, [M,1]);
    fix_i = fix(z,:);
    [fsig2, nu] = FitGaussianForCentralBias(fix_i, 0.75, Sig2);
    perSubj = FitGaussianPerSubject(fix);%, 0.75, Sig2
    nu2test(n,:) = [1 asprat nu 0.45];    
    sig(n) = fsig2;
    AUC(n,:) = ROCanalysisRepGauss(fix_i, [Sig2 fsig2], nu2test(n,:), 1, perSubj);
end


