% do everything script
clear all;
close all

addpath('../helperFunctions/')

nRep = 1;
Sig2 = 0.22;


figure('position', [0 0 1000 1000]);
z = 0.15;
w = 0.15;

axis_title_font_size = 20;
default_font_size = 13;
%MarkerSize = 12;
default_linewidth = 1.5;
plot_linewidth = 2;
axis_linewidth = 1.5;


axes('position', [w, ((1-z)*2)/3+z, (1-2*w)/4, (1-2*z)/3]);
fix = grabFixations('Clarke2013');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(1,:) = [1 0.75 nu 0.45];
sig(1) = fsig2;
%AUC.clarke2013 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(1,:), nRep, 0.75);
title('Clarke 2013', 'fontsize', axis_title_font_size)
ylabel('log(likelihood)', 'fontsize', axis_title_font_size);


axes('position', [(1-w)/4+w, ((1-z)*2)/3+z, (1-2*w)/4, (1-2*z)/3]);
fix = grabFixations('Yun2013SUN');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(2,:) = [1 0.75 nu 0.45];
sig(2) = fsig2;
%AUC.yun2013sun =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(2,:), nRep, 0.75);
title('Yun 2013 - SUN', 'fontsize', axis_title_font_size)


axes('position', [((1-w)*2)/4+w, ((1-z)*2)/3+z, (1-2*w)/4, (1-2*z)/3]);
fix = grabFixations('Tatler2005');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(3,:) = [1 0.75 nu 0.45];
sig(3) = fsig2;
%AUC.tatler2005 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(3,:), nRep, 0.75);
title('Tatler 2005', 'fontsize', axis_title_font_size)


axes('position', [((1-w)*3)/4+w, ((1-z)*2)/3+z, (1-2*w)/4, (1-2*z)/3]);
fix = grabFixations('Einhauser2008');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(4,:) = [1 0.75 nu 0.45];
sig(4) = fsig2;
%AUC.einhauser2008 =  ROCanalysisRepGauss(fix, [Sig2, fsig2], nu2test(4,:), nRep, 0.75);
title('Einhauser 2008', 'fontsize', axis_title_font_size)

axes('position', [w, (1-z)/3+z, (1-2*w)/3, (1-2*z)/3]);
fix = grabFixations('Tatler2007freeview');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(5,:) = [1 0.75 nu 0.45];
sig(5) = fsig2;
%AUC.tatler2007freview =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(5,:), nRep, 0.75);
title('Tatler 2007 freeview', 'fontsize', axis_title_font_size)
ylabel('log(likelihood)', 'fontsize', axis_title_font_size);

axes('position', [(1-w)/3+w, (1-z)/3+z, (1-2*w)/3, (1-2*z)/3]);
fix = grabFixations('Judd2009');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(6,:) = [1 0.75 nu 0.45];
sig(6) = fsig2;
%AUC.judd2009 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(6,:), nRep, 0.75);
title('Judd 2009', 'fontsize', axis_title_font_size)

axes('position', [((1-w)*2)/3+w, (1-z)/3+z, (1-2*w)/3, (1-2*z)/3]);
fix = grabFixations('Yun2013PASCAL');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(7,:) = [1 0.75 nu 0.45];
sig(7) = fsig2;
%AUC.yun2913pascal =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(7,:), nRep, 0.75);
title('Yun 2013 - PASCAL', 'fontsize', axis_title_font_size)

axes('position', [w, z, (1-2*w)/3, (1-2*z)/3]);
fix = grabFixations('Ehinger2009TA');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(8,:) = [1 0.75 nu 0.45];
sig(8) = fsig2;
%AUC.ehinger2009 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(8,:), nRep, 0.75);
title('Ehinger 2009', 'fontsize', axis_title_font_size)
ylabel('log(likelihood)', 'fontsize', axis_title_font_size);
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size+4);

axes('position', [((1-w))/3+w, z, (1-2*w)/3, (1-2*z)/3]);
fix = grabFixations('Tatler2007searchTA');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(9,:) = [1 0.75 nu 0.45];
sig(9) = fsig2;
%AUC.tatler2007search =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(9,:), nRep, 0.75);
title('Tatler 2007 Search', 'fontsize', axis_title_font_size)
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size+4);

axes('position', [((1-w)*2)/3+w, z, (1-2*w)/3, (1-2*z)/3]);
fix = grabFixations('Asher2013TA');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.80, Sig2);
nu2test(10,:) = [1 0.80 nu 0.45];
%AUC.asher2013 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(10,:), nRep, 0.8);
sig(10) = fsig2;
title('Asher 2013', 'fontsize', axis_title_font_size)
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size+4);

% axes('position', [((1-w)*3)/4+w, z, (1-2*w)/4, (1-2*z)/3]);
% fix = grabFixations('Clarke2009');
% [fsig2, nu] = FitGaussianForCentralBias(fix, 0.80, Sig2);
% nu2test(11,:) = [1 0.80 nu 0.45];
% %AUC.asher2013 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(11,:), nRep, 0.8);
% sig(11) = fsig2;
% title('Clarke 2009', 'fontsize', 14)


set(gcf, 'Color', 'w');
export_fig LogLikForDifferentDatasets.pdf


%% calc mean fsig2 and nu (not including Ehinger)
figure('position', [0 0 700 400]);

subplot(1,2,1);
hist(sig, 0.025:0.05:1, 'k');
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.5 .5 .5],'EdgeColor','k')

meanSig = mean(sig);
xlabel('$\sigma^2$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size);
ylabel('Number of datasets', 'fontsize', axis_title_font_size);
title('Horizontal variance of fixation data', 'fontsize', axis_title_font_size-4);
hold all
plot([meanSig meanSig], [0 5], '-k', 'linewidth', 2);
axis([0 0.4 0 5])


subplot(1,2,2);
hist(nu2test(:,3), 0.025:0.05:1);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[.5 .5 .5],'EdgeColor','k')
hold all
plot([0.75 0.75], [0 5], ':k', 'linewidth', 2)
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size);
tmp = nu2test;
tmp(7,:) = [];
meanNu = mean(tmp(:,3));
plot([meanNu meanNu], [0 5], '-k', 'linewidth', 2);
title('Ratio of vertical to horizonal variance', 'fontsize', axis_title_font_size);
set(gcf, 'Color', 'w');
export_fig nuDist.pdf

