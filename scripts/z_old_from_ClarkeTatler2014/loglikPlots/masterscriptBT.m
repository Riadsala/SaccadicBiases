% do everything script
clear all;
close all

addpath('../helperFunctions/')

nRep = 1;
Sig2 = 0.22;


figure('position', [0 0 1000 1000]);
z = 0.15;
w = 0.15;

extreme_left_axis_x = .1;
extreme_right_axis_x = .95;
panel_spacing = .06;

extreme_top_axis = .9;
extreme_bottom_axis = .1;

panel_height = (extreme_top_axis - extreme_bottom_axis - 2*panel_spacing)/3;
bottom_to_bottom_axis_gap = panel_height+ panel_spacing;

panel_width3 = (extreme_right_axis_x - extreme_left_axis_x - 2*panel_spacing)/3;
left_to_left_axis_gap3 = panel_width3 + panel_spacing;



panel_width4 = (extreme_right_axis_x - extreme_left_axis_x - 3*panel_spacing)/4;
left_to_left_axis_gap4 = panel_width4 + panel_spacing;


top_row.panel(1).posn = [extreme_left_axis_x, extreme_bottom_axis+2*bottom_to_bottom_axis_gap, panel_width4, panel_height];
top_row.panel(2).posn = [extreme_left_axis_x+left_to_left_axis_gap4, extreme_bottom_axis+2*bottom_to_bottom_axis_gap, panel_width4, panel_height];
top_row.panel(3).posn = [extreme_left_axis_x+2*left_to_left_axis_gap4, extreme_bottom_axis+2*bottom_to_bottom_axis_gap, panel_width4, panel_height];
top_row.panel(4).posn = [extreme_left_axis_x+3*left_to_left_axis_gap4, extreme_bottom_axis+2*bottom_to_bottom_axis_gap, panel_width4, panel_height];

middle_row.panel(1).posn = [extreme_left_axis_x, extreme_bottom_axis+bottom_to_bottom_axis_gap, panel_width3, panel_height];
middle_row.panel(2).posn = [extreme_left_axis_x+left_to_left_axis_gap3, extreme_bottom_axis+bottom_to_bottom_axis_gap, panel_width3, panel_height];
middle_row.panel(3).posn = [extreme_left_axis_x+2*left_to_left_axis_gap3, extreme_bottom_axis+bottom_to_bottom_axis_gap, panel_width3, panel_height];

bottom_row.panel(1).posn = [extreme_left_axis_x, extreme_bottom_axis, panel_width3, panel_height];
bottom_row.panel(2).posn = [extreme_left_axis_x+left_to_left_axis_gap3, extreme_bottom_axis, panel_width3, panel_height];
bottom_row.panel(3).posn = [extreme_left_axis_x+2*left_to_left_axis_gap3, extreme_bottom_axis, panel_width3, panel_height];


%axes('position', );



axis_title_font_size = 20;
default_font_size = 16;
%MarkerSize = 12;
default_linewidth = 1.15;
plot_linewidth = 2;


axes('position', top_row.panel(1).posn);
fix = grabFixations('Clarke2013');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(1,:) = [1 0.75 nu 0.45];
sig(1) = fsig2;
%AUC.clarke2013 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(1,:), nRep, 0.75);
title('Clarke 2013', 'fontsize', axis_title_font_size)
ylabel('log(likelihood)', 'fontsize', axis_title_font_size);


axes('position', top_row.panel(2).posn);
fix = grabFixations('Yun2013SUN');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(2,:) = [1 0.75 nu 0.45];
sig(2) = fsig2;
%AUC.yun2013sun =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(2,:), nRep, 0.75);
title('Yun 2013 - SUN', 'fontsize', axis_title_font_size)


axes('position', top_row.panel(3).posn);
fix = grabFixations('Tatler2005');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(3,:) = [1 0.75 nu 0.45];
sig(3) = fsig2;
%AUC.tatler2005 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(3,:), nRep, 0.75);
title('Tatler 2005', 'fontsize', axis_title_font_size)


axes('position', top_row.panel(4).posn);
fix = grabFixations('Einhauser2008');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(4,:) = [1 0.75 nu 0.45];
sig(4) = fsig2;
%AUC.einhauser2008 =  ROCanalysisRepGauss(fix, [Sig2, fsig2], nu2test(4,:), nRep, 0.75);
title('Einhauser 2008', 'fontsize', axis_title_font_size)

axes('position', middle_row.panel(1).posn);
fix = grabFixations('Tatler2007freeview');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(5,:) = [1 0.75 nu 0.45];
sig(5) = fsig2;
%AUC.tatler2007freview =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(5,:), nRep, 0.75);
title('Tatler 2007 - Freeview', 'fontsize', axis_title_font_size)
ylabel('log(likelihood)', 'fontsize', axis_title_font_size);

axes('position', middle_row.panel(2).posn);
fix = grabFixations('Judd2009');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(6,:) = [1 0.75 nu 0.45];
sig(6) = fsig2;
%AUC.judd2009 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(6,:), nRep, 0.75);
title('Judd 2009', 'fontsize', axis_title_font_size)

axes('position', middle_row.panel(3).posn);
fix = grabFixations('Yun2013PASCAL');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(7,:) = [1 0.75 nu 0.45];
sig(7) = fsig2;
%AUC.yun2913pascal =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(7,:), nRep, 0.75);
title('Yun 2013 - PASCAL', 'fontsize', axis_title_font_size)

axes('position', bottom_row.panel(1).posn);
fix = grabFixations('Ehinger2009TA');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(8,:) = [1 0.75 nu 0.45];
sig(8) = fsig2;
%AUC.ehinger2009 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(8,:), nRep, 0.75);
title('Ehinger 2009', 'fontsize', axis_title_font_size)
ylabel('log(likelihood)', 'fontsize', axis_title_font_size);
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size);

axes('position', bottom_row.panel(2).posn);
fix = grabFixations('Tatler2007searchTA');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(9,:) = [1 0.75 nu 0.45];
sig(9) = fsig2;
%AUC.tatler2007search =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(9,:), nRep, 0.75);
title('Tatler 2007 - Search', 'fontsize', axis_title_font_size)
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size);

axes('position', bottom_row.panel(3).posn);
fix = grabFixations('Asher2013TA');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.80, Sig2);
nu2test(10,:) = [1 0.80 nu 0.45];
%AUC.asher2013 =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(10,:), nRep, 0.8);
sig(10) = fsig2;
title('Asher 2013', 'fontsize', axis_title_font_size)
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size);

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
set(h,'FaceColor',[0.5 .5 .5],'EdgeColor','k','linewidth',default_linewidth)
set(gca,'linewidth',default_linewidth,'TickDir','out','fontsize',default_font_size)
set(gca,'YLim',[0 5],'YTick',[0:1:5])
meanSig = mean(sig);
xlabel('$\sigma^2$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size);
ylabel('Number of datasets', 'fontsize', axis_title_font_size);
title('Horizontal variance of fixation data', 'fontsize', axis_title_font_size-4);
hold all
plot([meanSig meanSig], [0 5], '-k', 'linewidth', plot_linewidth);
axis([0 0.4 0 5])


subplot(1,2,2);
hist(nu2test(:,3), 0.025:0.05:1);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[.5 .5 .5],'EdgeColor','k','linewidth',default_linewidth)
set(gca,'linewidth',default_linewidth,'TickDir','out','fontsize',default_font_size)
set(gca,'YLim',[0 5],'YTick',[0:1:5])
set(gca,'XLim',[0 1],'XTick',[0:.25:1])
hold all
plot([0.75 0.75], [0 5], ':k', 'linewidth', plot_linewidth)
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size);
tmp = nu2test;
tmp(7,:) = [];
meanNu = mean(tmp(:,3));
plot([meanNu meanNu], [0 5], '-k', 'linewidth', plot_linewidth);
title('Ratio of vertical to horizonal variance', 'fontsize', axis_title_font_size-4);
set(gcf, 'Color', 'w');
export_fig nuDist.pdf

