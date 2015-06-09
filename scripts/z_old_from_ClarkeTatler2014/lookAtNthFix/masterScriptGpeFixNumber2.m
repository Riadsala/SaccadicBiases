% do everything script
clear all;
close all
addpath('../helperFunctions')

nReps = 1;
Sig2 = 0.22;
% 
figure('position', [0 0 1000 600]);

%% clarke2013

fix = grabFixations('Clarke2013');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(1,:) = sig;
Nu(1,:) = nu;
Loglik(1,:) = lik;


%% Yun2013Sun
disp('yun2013')
fix = grabFixations('Yun2013SUN');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(2,:) = sig;
Nu(2,:) = nu;
Loglik(2,:) = lik;

%% Tatler2005
disp('tatler2005')
fix = grabFixations('Tatler2005');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(3,:) = sig;
Nu(3,:) = nu;
Loglik(3,:) = lik;

%% Einhauser2008
disp('einhauser2008')
fix = grabFixations('Einhauser2008');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(4,:) = sig;
Nu(4,:) = nu;
Loglik(4,:) = lik;

%% Tatler2007freeview
disp('tatler2007fv')
fix = grabFixations('Tatler2007freeview');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(5,:) = sig;
Nu(5,:) = nu;
Loglik(5,:) = lik;

%% Judd2009
disp('judd2009')
fix = grabFixations('Judd2009');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(6,:) = sig;
Nu(6,:) = nu;
Loglik(6,:) = lik;

%% Yun2013Pascal
disp('yuin2013pascal')
fix = grabFixations('Yun2013PASCAL');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(7,:) = sig;
Nu(7,:) = nu;
Loglik(7,:) = lik;

%% Ehinger2009
disp('ehinger2009')
fix = grabFixations('Ehinger2009TA');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(8,:) = sig;
Nu(8,:) = nu;
Loglik(8,:) = lik;

%% Tatler2007
disp('tatler2007')
fix = grabFixations('Tatler2007searchTA');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(9,:) = sig;
Nu(9,:) = nu;
Loglik(9,:) = lik;

%% Asher2013
disp('asher2013')
fix = grabFixations('Asher2013TA');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'equal');
Sig(10,:) = sig;
Nu(10,:) = nu;
Loglik(10,:) = lik;

% matlabpool close
N=20;


%plotting stuff
axis_title_font_size = 20;
default_font_size = 16;
default_linewidth = 1.15;
plot_linewidth = 2;
plot_linewidth2 = 1;



%now the plots
subplot(2, 2,1)
plot(2:N, nanmean(Sig), 'k-', 'linewidth', plot_linewidth)
hold all
plot(2:N, Sig', 'k:', 'linewidth', plot_linewidth2)
% fit curve
[b, ~,~,~, stats] = regress(mean(Sig)', [ones(1,19); 1./((2:20))]');
disp('coefs for ordinal sig')
b
 X = b(1) + b(2) .*1./((2:0.1:20));
% plot((2:0.1:N), X, 'k-', 'linewidth', plot_linewidth)
xlabel('Ordinal fixation number', 'fontsize', axis_title_font_size)
ylabel('$\sigma^2$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size+8)
set(gca,'linewidth',default_linewidth,'TickDir','out','fontsize',default_font_size)


subplot(2,2,2);
 plot(2:N, nanmean(Nu), 'k-', 'linewidth', plot_linewidth)
hold all
plot(2:N, Nu', 'k:', 'linewidth', plot_linewidth2)
[b, ~,~,~, stats] = regress(mean(Nu)', [ones(1,19); (1./exp(2:20))]');
disp('coefs for ordinal nu')
b
X = b(1) + b(2) .*(1./exp(2:0.1:20));
%  plot((2:0.1:N), X, 'k-', 'linewidth', plot_linewidth)
xlabel('Ordinal fixation number', 'fontsize', axis_title_font_size)
ylabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size+8)
set(gca,'linewidth',default_linewidth,'TickDir','out','fontsize',default_font_size)

set(gcf, 'Color', 'w');

% 
% subplot(2, ,3)
% plot(2:N, Loglik, 'k:', 'linewidth', 0.75)
% hold all
% plot(2:N, nanmean(Loglik), 'k', 'linewidth', 2);
% xlabel('Ordinal fixation number', 'fontsize', 14)
% ylabel('mean log(likelihood)', 'fontsize', 14)
 
%%%%%%%
clear all
nReps = 1;
Sig2 = 0.22;

%% clarke2013
disp('clarke2013')
fix = grabFixations('Clarke2013');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(1,:) = sig;
Nu(1,:) = nu;
Loglik(1,:) = lik;

%% Yun2013Sun
disp('yun2013')
fix = grabFixations('Yun2013SUN');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(2,:) = sig;
Nu(2,:) = nu;
Loglik(2,:) = lik;

%% Tatler2005
disp('tatler2005')
fix = grabFixations('Tatler2005');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(3,:) = sig;
Nu(3,:) = nu;
Loglik(3,:) = lik;

%% Einhauser2008
disp('einhauser2008')
fix = grabFixations('Einhauser2008');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(4,:) = sig;
Nu(4,:) = nu;
Loglik(4,:) = lik;

%% Tatler2007freeview
disp('tatler2007fv')
fix = grabFixations('Tatler2007freeview');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(5,:) = sig;
Nu(5,:) = nu;
Loglik(5,:) = lik;

%% Judd2009
disp('judd2009')
fix = grabFixations('Judd2009');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(6,:) = sig;
Nu(6,:) = nu;
Loglik(6,:) = lik;

%% Yun2013Pascal
disp('yuin2013pascal')
fix = grabFixations('Yun2013PASCAL');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(7,:) = sig;
Nu(7,:) = nu;
Loglik(7,:) = lik;

%% Ehinger2009
disp('ehinger2009')
fix = grabFixations('Ehinger2009TA');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(8,:) = sig;
Nu(8,:) = nu;
Loglik(8,:) = lik;

%% Tatler2007
disp('tatler2007')
fix = grabFixations('Tatler2007searchTA');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(9,:) = sig;
Nu(9,:) = nu;
Loglik(9,:) = lik;

%% Asher2013
disp('asher2013')
fix = grabFixations('Asher2013TA');
[sig nu lik] = FitGaussPerFixN(fix, nReps, Sig2, 'leq');
Sig(10,:) = sig;
Nu(10,:) = nu;
Loglik(10,:) = lik;

% matlabpool close
N=20;

subplot(2, 2,3)
plot(2:N, nanmean(Sig), 'k-', 'linewidth', plot_linewidth)
hold all
plot(2:N, Sig', 'k:', 'linewidth', plot_linewidth2)
% fit curve
[b, ~,~,~, stats] = regress(mean(Sig)', [ones(1,19); 1./((2:20))]');
 X = b(1) + b(2) .*1./((2:0.1:20));
% plot((2:0.1:N), X, 'k-', 'linewidth', 2)
xlabel('Number of fixations in trial', 'fontsize', axis_title_font_size)
ylabel('$\sigma^2$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size+8)
set(gca, 'fontsize', 14)
set(gca,'linewidth',default_linewidth,'TickDir','out','fontsize',default_font_size)

disp('coefs for fix so far sigma')
b

subplot(2, 2,4);
 plot(2:N, nanmean(Nu), 'k-', 'linewidth', plot_linewidth)
hold all
plot(2:N, Nu', 'k:', 'linewidth', plot_linewidth2)
[b, ~,~,~, stats] = regress(mean(Nu)', [ones(1,19); (1./exp(2:20))]');
 X = b(1) + b(2) .*(1./exp(2:0.1:20));
  %plot((2:0.1:N), X, 'k-', 'linewidth', 2)
xlabel('Number of fixations in trial', 'fontsize', axis_title_font_size)
ylabel('$\nu$', 'Interpreter','LaTex', 'fontsize', axis_title_font_size+8)
set(gca,'linewidth',default_linewidth,'TickDir','out','fontsize',default_font_size)
set(gcf, 'Color', 'w');


disp('coefs for fix so far nu')
b
% 
% subplot(2, 3,6)
% plot(2:N, Loglik, 'k:', 'linewidth', 0.75)
% hold all
% plot(2:N, nanmean(Loglik), 'k', 'linewidth', 2);
% xlabel('Number of fixations in trial', 'fontsize', 14)
% ylabel('mean log(likelihood)', 'fontsize', 14)

export_fig lookAtNthFix.pdf
