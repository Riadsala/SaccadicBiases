function perSubj = FitGaussianForCentralBias(allfix)

obs = unique(allfix(:,1));

for s = obs'

    fix = allfix(allfix(:,1)==s, :);
%     fix = fix(randi(length(fix), [1 length(fix)]),:);
    
    
    nfix = length(fix);
    
    fixX = fix(:,3);
    fixY = fix(:,4);
    
    
    % we're going to assume mean = [0, 0] and cov = [sig, 0; 0 nu*sig]
    perSubj(s).sig2 = (mean(fixX.^2));
    perSubj(s).nu = (mean(fixY.^2))/perSubj(s).sig2;
    perSubj(s).fix = fix;
    
end