function AUC = ROCanalysisRepGauss(fix, Sig2, Nu, nRep, perSubj)

%% we're Bootstrapping, so randomly sample F
% list of alpha values we want to explore
% does everything several times so we can have error bars

AUC = zeros(nRep, length(Nu),1);
nfix = length(fix);
C = [ones(nfix,1); zeros(nfix,1)];


for r = 1:nRep
    % generate some random fixations
    uniX = 2*(rand(nfix,1) - 0.5);
    uniY = 1.5*(rand(nfix,1) - 0.5);
    % bootstrap - randomly sample from fixations
    if nRep>1
        samples = randi(length(fix), [length(fix),1]);
        fixX = fix(samples,3);
        fixY = fix(samples,4);
    else
        fixX = fix(:,3);
        fixY = fix(:,4);
    end
    
    for n = 1:length(Nu)
        
        nu = Nu(n);
        
        F = [fixX, fixY; uniX, uniY];
        if n == 4
            sigma = Sig2(1);
        else
            sigma = Sig2(2);
        end
        D =  mvnpdf(F, [0 0], [sigma, 0; 0, nu*sigma]);        
        b = glmfit(D, C, 'binomial');
        yfit = glmval(b, D, 'logit');
        [~,~,~,auc] = perfcurve(C,yfit,1);
        AUC(r, n) = auc;
    end
end

subjsAUC = ROCanalysisRepGaussPerSubject(perSubj);
AUC(1,n+1) = mean(subjsAUC);
AUC(1,n+2) = median(subjsAUC);

% 
% plot(Nu, AUC, ':k', 'linewidth', 2);
% xlabel('nu');
% ylabel('AUC');
% hold on
% if nRep > 1
%     plot(Nu, mean(AUC), '-k', 'linewidth', 2);
% else
%     plot(Nu, AUC, '-k', 'linewidth', 2);
% end
% 
% plot([1, 1], [0 1], 'k:')
% plot([min(Nu) max(Nu)], [AUC(Nu==1) AUC(Nu==1)], 'k:')
% plot([aspRat, aspRat], [0 1], 'k:')
% plot([min(Nu) max(Nu)], [AUC(Nu==aspRat) AUC(Nu==aspRat)], 'k:')
% % plot([nu_best, nu_best], [0 1], 'k:')
% 
% 
% axis([Nu(1) Nu(end) min(AUC(:))-0.01, max(AUC(:))+0.01])
% 
% % plot best result
% 
% [~, m] = max(AUC);
% plot([Nu(m), Nu(m)], [0, 1], 'k:', 'linewidth', 2)
% plot([min(Nu), max(Nu)], [max(AUC), max(AUC)], 'k:', 'linewidth', 2)
% 
% title('AUCs over all subjects')
% 
