% do everything script
clear all;
close all

addpath('../helperFunctions/')

nRep = 1;
Sig2 = 0.22;


figure('position', [0 0 1000 1000]);
z = 0.15;
w = 0.15;



fix = grabFixations('Tatler2007freeview');
[fsig2, nu] = FitGaussianForCentralBias(fix, 0.75, Sig2);
nu2test(5,:) = [1 0.75 nu 0.45];
sig(5) = fsig2;
%AUC.tatler2007freview =  ROCanalysisRepGauss(fix, [Sig2 fsig2], nu2test(5,:), nRep, 0.75);
title('Tatler 2007 freeview', 'fontsize', 14)
ylabel('log(likelihood)', 'fontsize', 14);
xlabel('$\nu$', 'Interpreter','LaTex', 'fontsize', 14);

set(gcf, 'Color', 'w');
export_fig oneLLKplot.pdf