% function simpleROCanalysis
clear all
close all


R = dlmread('DatabaseCode/juddFixData_TrialSubjFixNXY.txt');

% remove inital fixation
R(R(:,3)==1,:) = [];

% remove NaNs
R(isnan(R(:,4)),:) = [];
R(isnan(R(:,5)),:) = [];



% get fixations from most common aspect ratio only




% figure('position', [0 0 1200 600])
% subplot(1,2,1);
% b = 0.05;
% plot(-1:b:1, hist(fixX, -1:b:1), '-o')
% hold all
% plot(-1:b:1, hist(fixY, -1:b:1), '-o')
% clear b

% now calculate how far each fix is away from the centre based on some
% different metrics


A = 0.8:0.05:2;

for s = 1:15
    idx = find((R(:,2)==s).*(R(:,6)==1024).*(R(:,7)==768));
    nfix = length(idx);
    
    C = [ones(nfix,1); zeros(nfix,1)];
    % centre of image should = [0,0], and transform to a square of width 2
    fixX = (R(idx,4) - 512)/512;
    fixY = (R(idx,5) - 384)/512;
    
    uniX = 2*(rand(nfix,1) - 0.5);
    uniY = 1.5*(rand(nfix,1) - 0.5);
    
    for a = 1:length(A)
        
        [s a]
        
        
        alpha = A(a);
        F = [fixX, alpha*fixY; uniX, alpha*uniY];
        D = pdist2(F, [0, 0], 'minkowski', 2);
        [b,dev,stats] = glmfit(D, C, 'binomial');
        yfit = glmval(b, D, 'logit');
        [X,Y,T,auc] = perfcurve(C,yfit,1);
        AUC(s,a) = auc;
    end
end

p1 = plot(A, AUC, 'linewidth', 2);
xlabel('weight for Y in Euclidean distance');
ylabel('AUC');
hold on
% plot([1, 1], [.7 1], 'k:', 'linewidth', 2)
% plot([A(1) A(end)], [ AUC(find(A==1)),  AUC(find(A==1))], 'k:', 'linewidth', 2)
axis([A(1) A(end) 0.7, 0.9])
plot([1.33, 1.33], [.7 1], 'k--', 'linewidth', 2)
% plot([0.8, 2], [max(AUC), max(AUC)], 'k-', 'linewidth', 2)
for s = 1:15
[~, m] = max(AUC(s,:));
plot([A(m), A(m)], [0, 1], 'k:', 'linewidth', 2)
end
title(['max AUC for scaling y by a = ' num2str(A(m), 3) ' ->  AUC = ' num2str(max(AUC), 3) ])
export_fig judd2009_auc_subject.png
