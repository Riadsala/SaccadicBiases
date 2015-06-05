%% make boxplots
function makeAllBoxplots
clear all
close all

load AUC_CI95

figure('position', [0 0 1000 800]);

h =subplot(3,12,1:3);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.clarke2013;
drawBoxplot(auc, 'Clarke 2013');
ylabel('AUC')

h=subplot(3,12,4:6);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.yun2013sun;
drawBoxplot(auc, 'Yun 2013 (Sun)');

h=subplot(3,12,7:9);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.tatler2005
drawBoxplot(auc, 'Tatler 2005');

h=subplot(3,12,10:12);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.einhauser2008
drawBoxplot(auc, 'Einhauser 2008');

h=subplot(3,12,13:16);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.tatler2007freeview;
drawBoxplot(auc, 'Tatler 2007 (freeview)');
ylabel('AUC')

h=subplot(3,12,17:20);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.judd2009
drawBoxplot(auc, 'Judd 2009');

h=subplot(3,12,21:24);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.yun2013pascal;
drawBoxplot(auc, 'Yun 2013 (Pascal)');

h=subplot(3,12,25:28);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.ehinger2009;
drawBoxplot(auc, 'Ehinger 2009');
ylabel('AUC')

h= subplot(3,12,29:32);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.tatler2007search
drawBoxplot(auc, 'Tatler 2007 (search)');

h= subplot(3,12,33:36);
ax = get(h, 'Position');
ax(3) = ax(3)-0.025;
set(h, 'Position', ax);
auc = AUC.asher2013;
drawBoxplot(auc, 'Asher 2013');

% h= subplot(3,12,34:36);
% ax = get(h, 'Position');
% ax(3) = ax(3)-0.025;
% set(h, 'Position', ax);
% auc = AUC.clarke2009;
% drawBoxplot(auc, 'Clarke 2009');

set(gcf, 'Color', 'w');
export_fig boxplots.pdf

end


function drawBoxplot(auc, dataset)

boxplot(auc(:,[1 2 3 5 4]), {'isotropic', 'aspect ratio', 'experiment fitted', 'subject fitted', 'baseline'}, 'boxstyle', 'filled' , 'colors', 'k', 'symbol', 'k.', 'whisker', Inf);

fontSize = 12;
text_h = findobj(gca, 'Type', 'text');
tickLabelStr = {'isotropic', 'aspect ratio', 'exp. fitted', 'subject fitted', 'baseline'};
    rotation = 45;
    
    for cnt = 1:length(text_h)
        set(text_h(cnt),    'FontSize', fontSize,...
                            'Rotation', rotation, ...
                            'String', tickLabelStr{length(tickLabelStr)-cnt+1}, ...
                            'HorizontalAlignment', 'right')
    end
set(gca, 'fontsize', 12)
title(dataset, 'fontsize', 14)
end