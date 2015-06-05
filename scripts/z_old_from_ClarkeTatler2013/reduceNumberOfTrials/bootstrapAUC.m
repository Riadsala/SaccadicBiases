function [AUCfit AUCbl] = bootstrapAUC(fix, nReps, Sig2, asprat)

obs = unique(fix(:,2));

% split into training and testing sets
trials = unique(fix(:,1));
M = length(trials);
idx = randperm(M);
idx = trials(idx);
f = floor(M/10);
fold{1}  = idx(1:f);
fold{2}  = idx((f+1):(2*f));
fold{3}  = idx((2*f+1):(3*f));
fold{4}  = idx((3*f+1):(4*f));
fold{5}  = idx((4*f+1):(5*f));
fold{6}  = idx((5*f+1):(6*f));
fold{7}  = idx((6*f+1):(7*f));
fold{8}  = idx((7*f+1):(8*f));
fold{9}  = idx((8*f+1):(9*f));
fold{10} = idx((9*f+1):(10*f));
clear f

for f = 1:10;
    disp(['FOLD ' num2str(f)]);
    testSet = fold{f};
    trainSet = idx(~ismember(idx, fold{f}));
    Mt = length(trainSet);
    
    for i = 1:nReps
        % randomly re-permute trainnig set so things are in a different order
        trainSet = trainSet(randperm(length(trainSet)));
        % add in random points now, so they are constant over experiment
        uniX = 2*(rand(length(fix),1) - 0.5);
        uniY = 1.5*(rand(length(fix),1) - 0.5);
        fix(:,6:7) = [uniX uniY];
        fix_t = [];
        testFix = fix(ismember(fix(:,1), testSet),:);
        unique(testFix(:,2))
        for n = 1:25
 
            fix_t = [fix_t; fix(fix(:,1)==trainSet(n),:)];
            %     [fsig2, nu] = FitGaussianForCentralBias(fix_i, 0.75, Sig2);
            
            perSubj = FitGaussianPerSubject(fix_t, testFix, obs);
            %     nu2test(n,:) = [1 asprat nu 0.45];
            %     sig(n) = fsig2;
            
            %% now test

            [aucfit aucbl] = ROCanalysisRepGaussPerSubject2(perSubj, [0.22, 0.45]);

            AUCfit(n,f,i,:) = aucfit;
            AUCbl(n,f,i,:) = aucbl;
        end
    end
    
end
