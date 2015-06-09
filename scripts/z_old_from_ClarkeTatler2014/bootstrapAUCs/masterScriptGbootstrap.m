% do everything script
clear all;
close all



nReps = 100;
Sig2 = 0.22;

%matlabpool 4;

%% clarke2013
fix = grabFixations('Clarke2013');
[AUC.clarke2013 sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.clarke2013 = quantile(AUC.clarke2013, [.5 .95]);

%% Yun2013Sun
fix = grabFixations('Yun2013SUN');
[AUC.yun2013sun sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.yun2013sun = quantile(AUC.yun2013sun, [.5 .95]);

%% Tatler2005
fix = grabFixations('Tatler2005');
[AUC.tatler2005 sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.tatler2005 = quantile(AUC.tatler2005, [.5 .95]);

%% Einhauser2008
fix = grabFixations('Einhauser2008');
[AUC.einhauser2008 sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.einhauser2008 = quantile(AUC.einhauser2008, [.5 .95]);

%% Tatler2007freeview
fix = grabFixations('Tatler2007freeview');
[AUC.tatler2007freeview sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.tatler2007freeview = quantile(AUC.tatler2007freeview, [.5 .95]);

%% Judd2009
fix = grabFixations('Judd2009');
[AUC.judd2009 sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.judd2009 = quantile(AUC.judd2009, [.5 .95]);

%% Yun2013Pascal
fix = grabFixations('Yun2013PASCAL');
[AUC.yun2013pascal sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.yun2013pascal = quantile(AUC.yun2013pascal, [.5 .95]);

%% Ehinger2009
fix = grabFixations('Ehinger2009TA');
[AUC.ehinger2009 sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.ehinger2009 = quantile(AUC.ehinger2009, [.5 .95]);

%% Tatlre2007
fix = grabFixations('Tatler2007searchTA');
[AUC.tatler2007search sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.75);
CI95.tatler2007search = quantile(AUC.tatler2007search, [.5 .95]);

%% Asher2013
fix = grabFixations('Asher2013TA');
[AUC.asher2013 sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 0.80);
CI95.asher2013 = quantile(AUC.asher2013, [.5 .95]);

% % Clarke 2009
% fix = grabFixations('Clarke2009');
% [AUC.clarke2009 sig nu2test] = bootstrapAUC(fix, nReps, Sig2, 1.00);
% CI95.clarke2009 = quantile(AUC.asher2013, [.5 .95]);

save AUC_CI95 AUC CI95

makeAllBoxplots