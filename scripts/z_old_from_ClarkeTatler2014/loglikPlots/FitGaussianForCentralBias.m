function [sig2 nu] = FitGaussianForCentralBias(fix, asprat, mSig2)

%% we're Bootstrapping, so randomly sample F
% list of alpha values we want to explore
% does everything several times so we can have error bars

Mu = 0.2:0.01:1.2;

nfix = length(fix);

fixX = fix(:,3);
fixY = fix(:,4);
%     M(n,:) = mean([fixX, fixY]);
%     S{n} = cov([fixX, fixY]);

% we're going to assume mean = [0, 0] and cov = [sig, 0; 0 nu*sig]
sig2 = (mean(fixX.^2));
nu = (mean(fixY.^2))/sig2;

plot_linewidth = 1;
plot_linewidth2 = 1.5;
plot_linewidth3 = 3;

default_linewidth = 1.15;

i = 0;
for mu = Mu
    i = i + 1;
    loglik(i) = sum(log(mvnpdf([fixX fixY], [0 0], [sig2, 0; 0 mu*sig2])));
    loglik0(i) = sum(log(mvnpdf([fixX fixY], [0 0], [mSig2, 0; 0 mu*sig2])));
end
r = range(loglik);
plot(Mu, loglik, 'k-', 'linewidth', plot_linewidth3)
hold all
%plot(Mu, loglik0, 'b-', 'linewidth', 2)
plot([1 1], [min(loglik) max(loglik)+0.1*r], 'k:','linewidth',plot_linewidth)
plot([0 2], [loglik(Mu==1) loglik(Mu==1)], ':k','linewidth',plot_linewidth);

plot([asprat asprat], [min(loglik) max(loglik)+0.1*r], 'k:','linewidth',plot_linewidth)
plot([0 2], [loglik(round(100000*Mu)==round(100000*asprat)) loglik(round(100000*Mu)==round(100000*asprat))], ':k','linewidth',plot_linewidth);

plot([0.45 0.45], [min(loglik) max(loglik)+0.1*r], 'k-','linewidth',plot_linewidth2)
plot([0 2], [loglik0(round(100000*Mu)==round(100000*0.45)) loglik0(round(100000*Mu)==round(100000*0.45))], '-k','linewidth',plot_linewidth2);


k = find(loglik == max(loglik));
plot([Mu(k), Mu(k)], [min(loglik) max(loglik)+0.1*r], 'k--','linewidth',plot_linewidth2)
plot([0 2], [loglik(Mu==Mu(k)) loglik(Mu==Mu(k))], '--k','linewidth',plot_linewidth2);


axis([min(Mu) max(Mu) min(loglik) max(loglik)+0.1*r]);

NumTicks = 5;
L = get(gca,'YLim');
ticks = linspace(L(1),L(2),NumTicks);
ticks = 100 * round(ticks/100);
set(gca,'YTick',ticks,'TickDir','out','linewidth',default_linewidth)
set(gca,'XLim',[0.2 1.2],'XTick',[0.2:0.2:1.2])
set(gca,'FontSize',12)

