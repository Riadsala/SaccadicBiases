function [sig2 nu, loglik] = FitGaussianForCentralBias(fix, asprat, mSig2)

%% we're Bootstrapping, so randomly sample F
% list of alpha values we want to explore
% does everything several times so we can have error bars

Mu = 0.2:0.01:1.1;

nfix = length(fix);

fixX = fix(:,3);
fixY = fix(:,4);
%     M(n,:) = mean([fixX, fixY]);
%     S{n} = cov([fixX, fixY]);

% we're going to assume mean = [0, 0] and cov = [sig, 0; 0 nu*sig]
sig2 = (mean(fixX.^2));
nu = (mean(fixY.^2))/sig2;

i = 0;
for mu = Mu
    i = i + 1;
    loglik(i) = mean(log(mvnpdf([fixX fixY], [0 0], [sig2, 0; 0 mu*sig2])));
    loglik0(i) = mean(log(mvnpdf([fixX fixY], [0 0], [mSig2, 0; 0 mu*sig2])));
end
