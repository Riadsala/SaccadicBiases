% function simpleROCanalysis
clear all
close all


R = dlmread('ProcessedFixations.txt');

% remove inital fixation
R(R(:,3)==1,:) = [];

% remove NaNs
R(isnan(R(:,6)),:) = [];
R(isnan(R(:,7)),:) = [];


for s = 1:24
    idx = find(R(:,1)==s);
    
    % centre of image should = [0,0], and transform to a square of width 2
    fixX = (R(idx,6) - 400)/400;
    fixY = (R(idx,7) - 300)/400;  
    
    nfix = length(fixX);
    

    A = [0.8:0.02:2.5];
    M = 2;
    uniX = 2*(rand(nfix,1) - 0.5);
    uniY = 1.5*(rand(nfix,1) - 0.5);
    C = [ones(nfix,1); zeros(nfix,1)];
    for a = 1:length(A)
        alpha = A(a);
        D = sqrt(fixX.^2 + (alpha*fixY).^2);
        D = [D; sqrt(uniX.^2 + (alpha*uniY).^2)];
        [b,dev,stats] = glmfit(D, C, 'binomial');
        yfit = glmval(b, D, 'logit');
        [X,Y,T,auc] = perfcurve(C,yfit,1);
        AUC(a) = auc;
    end
    
    
    p1 = plot(A, AUC, 'linewidth', 2);
    [~, m] = max(AUC);
plot([A(m), A(m)], [0, 1], 'k:', 'linewidth', 2)
    hold all
end
axis([A(1) A(end) 0.65, 0.8])

xlabel('weight for Y in Euclidean distance');
ylabel('AUC');
% hold on
% plot([1, 1], [0 1], 'k:', 'linewidth', 2)
% plot([A(1) A(end)], [ AUC(find(A==1)),  AUC(find(A==1))], 'k:', 'linewidth', 2)
 axis([A(1) A(end) min(AUC)-0.01, max(AUC)+0.01])
 plot([1.33, 1.33], [0 1], 'k--', 'linewidth', 2)
% plot([0.8, 6], [max(AUC), max(AUC)], 'k-', 'linewidth', 2)
axis([A(1) A(end) 0.65, 0.8])

title('performance per subject')
export_fig clarke2013_subject_auc.png
