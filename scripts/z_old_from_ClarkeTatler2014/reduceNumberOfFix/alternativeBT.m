clear all
close all


R = dlmread('../../data/Judd2009/DatabaseCode/juddFixData_TrialSubjFixNXY.txt');
% remove NaNs
R(R(:,4)<(-R(:,6)/2),:) = [];
R(R(:,5)<(-R(:,7)/2),:) = [];
R(R(:,4)>(R(:,6)/2),:) = [];
R(R(:,5)>(R(:,7)/2),:) = [];

R(isnan(R(:,4)),:) = [];
R(isnan(R(:,5)),:) = [];

R(:,4) = R(:,4) + R(:,6)/2;
R(:,5) = R(:,5) + R(:,7)/2;


% get fixations from most common aspect ratio only
idx = find(~((R(:,6)==1024).*(R(:,7)==768)));
R(idx,:) = [];


trs = R(:,1);
R(:,[6 7]) = [];

% remove initial fixation
if ~isempty(trs)
    trs(R(:,2)==1,:) = [];
end
R(R(:,3)==1,:) = [];

%R(:,4) = (R(:,4) - imX/2)/(imX/2);
%R(:,5) = (R(:,5) - (imY/2))/(imX/2);

fix = R;

%remove offscreen fixations
fix(round(fix(:,4)) <= 0,:) = [];
fix(round(fix(:,5)) <= 0,:) = [];

fix(round(fix(:,4)) > 1024,:) = [];
fix(round(fix(:,5)) > 768,:) = [];

%[AUC.judd2009.fit AUC.judd2009.bl] = bootstrapAUC(fix, nReps, Sig2, 0.75);

obs = unique(fix(:,2));

% add in random points now, so they are constant over experiment
uniX = 1024*(rand(length(fix),1));
uniY = 768*(rand(length(fix),1));
fix(:,6:7) = [uniX uniY];

nReps = 10;
Sig2 = 0.22;
maxNfix = 25;
bl = [0.22, 0.45];

%now cycle through observers
for s = obs'
    
    this_subj_data = fix(fix(:,2) == s,:);
    
    M = length(this_subj_data);
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
        for i = 1:nReps
            disp(sprintf('Running SUBJECT %d, FOLD %d, BOOTSTRAP SAMPLE %d',s,f,i))
            testSet = fold{f};
            trainSet = idx(~ismember(idx, fold{f}));
            Mt = length(trainSet);
            % randomly re-permute trainnig set so things are in a different order
            trainSet = trainSet(randperm(length(trainSet)));
            fix_t = [];
            testFix = this_subj_data(testSet,:);
            trainFix =this_subj_data(trainSet,:);
            
            %now cycle through by Nfix
            for n = 2:maxNfix
                m = size(trainFix,1);
                train_Nfix_set = trainFix(randperm(m),:);
                train_Nfix_set = train_Nfix_set(1:n, :);
                
                fixX = train_Nfix_set(:,4);
                fixY = train_Nfix_set(:,5);
                
                perSubj(s).fold(f).sig2(n) = (mean(fixX.^2));
                perSubj(s).fold(f).nu(n) = (mean(fixY.^2))/perSubj(s).fold(f).sig2(n);
                
                perSubj(s).fold(f).fix{n} = fix;
                perSubj(s).fold(f).testfix = testFix(testFix(:,2)==s, :);
                
                
                
                
                
            end
            
            
        end
        %now calculate AUC
        %for s = 1:length(perSubj)
        for n = 1:length(perSubj(s).fold(f).sig2)
            
            nfix = size(perSubj(s).fold(f).testfix,1);
            C = [ones(nfix,1); zeros(nfix,1)];
            
            fixX = perSubj(s).fold(f).testfix(:,4);
            fixY = perSubj(s).fold(f).testfix(:,5);
            
            uniX = perSubj(s).fold(f).testfix(:,6);
            uniY = perSubj(s).fold(f).testfix(:,7);
            
            nu = perSubj(s).fold(f).nu(n);
            sigma = perSubj(s).fold(f).sig2(n);
            
            F = [fixX, fixY; uniX, uniY];
            
             
            if isfinite(sigma) * (nu>0)
                % [sigma, 0; 0, nu*sigma]
                D =  mvnpdf(F, [0 0], [sigma, 0; 0, nu*sigma]);
                b = glmfit(D, C, 'binomial');
                yfit = glmval(b, D, 'logit');
                [~,~,~,auc] = perfcurve(C,yfit,1);
                AUCfit(s,f,n) = auc;
            else
                AUCfit(s,f,n) = NaN;
            end
            
           %now baseline 
            D =  mvnpdf(F, [0 0], [bl(1), 0; 0, bl(2)*bl(1)]);
            
            
            try
                b = glmfit(D, C, 'binomial');
            catch
                disp('<')
            end
            yfit = glmval(b, D, 'logit');
            [~,~,~,auc] = perfcurve(C,yfit,1);
            AUCbl(s,f,n) = auc;
        end
        %end
        
    end
    
    %[aucfit aucbl] = ROCanalysisRepGaussPerSubject2(perSubj, [0.22, 0.45]);
    
    %            AUCfit(f,i,:,:) = aucfit;
    %           AUCbl(f,i,:,:) = aucbl;
    
end %of subject loop



