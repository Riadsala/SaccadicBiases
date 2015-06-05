% function simpleROCanalysis
clear all
close all


R = dlmread('ehinger2007fixations.txt');

% remove inital fixation
R(R(:,3)==1,:) = [];

imX = 800;
imY = 600;
% remove NaNs
R(isnan(R(:,4)),:) = [];
R(isnan(R(:,5)),:) = [];
R(R(:,4)<0,:) = [];
R(R(:,5)<0,:) = [];
R(R(:,4)>imX,:) = [];
R(R(:,5)>imY,:) = [];


% centre of image should = [0,0], and transform to a square of width 2
fixX = (R(:,4) - imX/2)/(imX/2);
fixY = (R(:,5) - (imY/2))/(imX/2);

nfix = length(fixX);


A = 0.8:0.1:6;

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
xlabel('weight for Y in Euclidean distance');
ylabel('AUC');
hold on
plot([1, 1], [0 1], 'k:', 'linewidth', 2)
plot([A(1) A(end)], [ AUC(find(A==1)),  AUC(find(A==1))], 'k:', 'linewidth', 2)
axis([A(1) A(end) min(AUC)-0.01, max(AUC)+0.01])
plot([1.33, 1.33], [0 1], 'k:', 'linewidth', 2)
plot([0.8, 6], [max(AUC), max(AUC)], 'k-', 'linewidth', 2)
[~, m] = max(AUC);
plot([A(m), A(m)], [0, 1], 'k-', 'linewidth', 2)
title(['max AUC for scaling y by a = ' num2str(A(m), 3) ' ->  AUC = ' num2str(max(AUC), 3) ])
export_fig ehringer2007_auc.png
