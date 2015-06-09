function [AUCfit AUCbl] = bootstrapAUC(fix, nReps, Sig2, asprat)

obs = unique(fix(:,2));
maxNfix = 25;
% split into training and testing sets
M = length(fix);
idx = randperm(M);
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
        t1 = tic;
        disp(sprintf('Running FOLD %d, BOOTSTRAP SAMPLE %d',f,i))
        % randomly re-permute trainnig set so things are in a different order
        trainSet = trainSet(randperm(length(trainSet)));
        % add in random points now, so they are constant over experiment
        uniX = 2*(rand(length(fix),1) - 0.5);
        uniY = 1.5*(rand(length(fix),1) - 0.5);
        fix(:,6:7) = [uniX uniY];
        fix_t = [];
        testFix = fix(testSet,:);
        trainFix =fix(trainSet,:);
           
         perSubj = FitGaussianPerSubject(trainFix, testFix, obs, maxNfix);
            
            %% now test

            [aucfit aucbl] = ROCanalysisRepGaussPerSubject2(perSubj, [0.22, 0.45]);

            AUCfit(f,i,:,:) = aucfit;
            AUCbl(f,i,:,:) = aucbl;
            
            t2 = toc(t1);
            disp(sprintf('Time elapsed: %d minutes',t2/60))
        end
    end
    
end
