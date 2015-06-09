function perSubj = FitGaussianForCentralBias(trainfix, testfix, obs, maxNfix)


% if length(obs) ~= nObs
%     disp('why?')
% end



for s = obs'
    
    for n = 2:maxNfix
        
    
        fix = trainfix(trainfix(:,2)==s, :);
        
        size(fix)
        
        
    m = size(fix,1);
    fix = fix(randperm(m),:);
    fix = fix(1:n, :);

        
        nfix = length(fix)
        fixX = fix(:,4);
        fixY = fix(:,5);
        
        
        % we're going to assume mean = [0, 0] and cov = [sig, 0; 0 nu*sig]
        perSubj(s).sig2(n) = (mean(fixX.^2));
        perSubj(s).nu(n) = (mean(fixY.^2))/perSubj(s).sig2(n);
        
        

    
    perSubj(s).fix{n} = fix;
    perSubj(s).testfix = testfix(testfix(:,2)==s, :);
    %     size(perSubj(s).testfix)
    end
    
end