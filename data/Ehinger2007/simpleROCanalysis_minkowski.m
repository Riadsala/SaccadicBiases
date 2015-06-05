% function simpleROCanalysis
clear all
close all


R = dlmread('ProcessedFixations.txt');

% remove inital fixation
R(R(:,3)==1,:) = [];

% remove NaNs
R(isnan(R(:,6)),:) = [];
R(isnan(R(:,7)),:) = [];

% centre of image should = [0,0], and transform to a square of width 2
fixX = (R(:,6) - 400)/400;
fixY = (R(:,7) - 300)/400;

nfix = length(fixX);
%
% figure('position', [0 0 1200 600])
% subplot(1,2,1);
% b = 0.05;
% plot(-1:b:1, hist(fixX, -1:b:1), '-o')
% hold all
% plot(-1:b:1, hist(fixY, -1:b:1), '-o')
% clear b
% legend('x-axis', 'y-axis')
% now calculate how far each fix is away from the centre based on some
% different metrics


A = [1, 1.33, 1.51];
M = 1:0.05:3.5;
uniX = 2*(rand(nfix,1) - 0.5);
uniY = 1.5*(rand(nfix,1) - 0.5);
C = [ones(nfix,1); zeros(nfix,1)];
for a = 1:length(A)
    for m = 1:length(M)
        alpha = A(a);
        F = [fixX, alpha*fixY; uniX, alpha*uniY];
        D = pdist2(F, [0, 0], 'minkowski', M(m));
        
        [b,dev,stats] = glmfit(D, C, 'binomial');
        yfit = glmval(b, D, 'logit');
        [X,Y,T,auc] = perfcurve(C,yfit,1);
        AUC(a, m) = auc;
        
    end
end

p1 = plot(M, AUC, 'linewidth', 2);
xlabel('Minkowski exponenet');
ylabel('AUC');
hold on
plot([2, 2], [.7 1], 'k:', 'linewidth', 2)
for a = 1:length(A)
plot([M(1) M(end)], [ AUC(a,find(M==2)),  AUC(a,find(M==2))], 'k:', 'linewidth', 1)
plot([M(1) M(end)], [max(AUC(a,:)), max(AUC(a,:))], 'k:', 'linewidth', 1)
[~, m] = max(AUC(a,:));
plot([M(m), M(m)], [0, 1], 'k:', 'linewidth', 1)
end
axis([M(1) M(end) 0.725, 0.745])
legend('1', '1.33', '1.51', 'location', 'southeast')
[~, m] = max(AUC);
% plot([M(m), M(m)], [0, 1], 'k-', 'linewidth', 2)
title(['max AUC for scaling y by a = ' num2str(A(m), 3) ' ->  AUC = ' num2str(max(AUC), 3) ])
export_fig clarke2013_auc_minkowski.png
