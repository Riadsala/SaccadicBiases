function perSubj = FitGaussianForCentralBias(trainfix, testfix, obs)


% if length(obs) ~= nObs
%     disp('why?')
% end

for s = obs'
    
    fix = trainfix(trainfix(:,2)==s, :);
    if length(fix)>0
        
        nfix = length(fix);
        fixX = fix(:,4);
        fixY = fix(:,5);
        
        
        % we're going to assume mean = [0, 0] and cov = [sig, 0; 0 nu*sig]
        perSubj(s).sig2 = (mean(fixX.^2));
        perSubj(s).nu = (mean(fixY.^2))/perSubj(s).sig2;
        
        
    else
        perSubj(s).sig2 = NaN;
        perSubj(s).nu = NaN;
    end
    
    perSubj(s).fix = fix;
    perSubj(s).testfix = testfix(testfix(:,2)==s, :);
    %     size(perSubj(s).testfix)
    
end