% do everything script
clear all;
close all

addpath('../helperFunctions/');

nReps = 10 ;
Sig2 = 0.22;

 
% %% Judd2009
fix = grabFixationsTrialInfo('Judd2009');
disp('Judd2009')
[AUC.judd2009.fit AUC.judd2009.bl] = bootstrapAUC(fix, nReps, Sig2, 0.75);

%% Clarke2013
disp('Clarke2013')
fix = grabFixationsTrialInfo('Clarke2013');
fix(fix(:,2)==19, :) = [];
[AUC.clarke2013.fit AUC.clarke2013.bl] = bootstrapAUC(fix, nReps, Sig2, 0.75);
AUC.clarke2013.fit(:,:,19,:) = [];
AUC.clarke2013.bl(:,:,19,:) = [];
save smallNSim AUC


figure('position', [0 0 1000 600])

subplot(1,2,1);
fitAUC(:,:) = mean(mean(AUC.judd2009.fit,2),3);
plot(nanmean(fitAUC,2), 'k-', 'linewidth', 2);
hold all
bslAUC(:,:) = mean(mean(AUC.judd2009.bl,2),3);
plot(nanmean(bslAUC,2), 'k--', 'linewidth', 2);
title('Judd 2013', 'fontsize', 14)
xlabel('Number of Fixations', 'fontsize', 14)
ylabel('AUC', 'fontsize', 14)
%  
% clear fitAUC bslAUC
% subplot(1,3,2);
% fitAUC(:,:) = nanmean(nanmean(AUC.asher2013.fit,2),3);
% plot(mean(fitAUC,2), 'k-', 'linewidth', 2);
% hold all
% bslAUC(:,:) = nanmean(nanmean(AUC.asher2013.bl,2),3);
% plot(mean(bslAUC,2), 'k--', 'linewidth', 2);
% title('Asher 2013', 'fontsize', 14)
% xlabel('Number of Trials', 'fontsize', 14)



clear fitAUC bslAUC
subplot(1,2,2);
fitAUC(:,:) = nanmean(nanmean(AUC.clarke2013.fit,2),3);
plot(nanmean(fitAUC,2), 'k-', 'linewidth', 2);
hold all
bslAUC(:,:) = nanmean(nanmean(AUC.clarke2013.bl,2),3);
plot(nanmean(bslAUC,2), 'k--', 'linewidth', 2);
title('Yun 2014', 'fontsize', 14)
xlabel('Number of Fixations', 'fontsize', 14)

title('Clarke 2013', 'fontsize', 14); 


set(gcf, 'Color', 'w');
export_fig smallNsim.pdf

clear fitAUC bslAUC