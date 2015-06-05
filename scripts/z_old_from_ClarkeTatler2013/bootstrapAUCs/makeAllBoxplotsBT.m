%% make boxplots
function makeAllBoxplotsBT
clear all
close all

load AUC_CI95

figure('position', [0 0 1000 1000]);

extreme_left_axis_x = .1;
extreme_right_axis_x = .95;
panel_spacingH = .06;
panel_spacingV = .1;

extreme_top_axis = .9;
extreme_bottom_axis = .1;

panel_height = (extreme_top_axis - extreme_bottom_axis - 2*panel_spacingV)/3;
bottom_to_bottom_axis_gap = panel_height+ panel_spacingV;

panel_width3 = (extreme_right_axis_x - extreme_left_axis_x - 2*panel_spacingH)/3;
left_to_left_axis_gap3 = panel_width3 + panel_spacingH;



panel_width4 = (extreme_right_axis_x - extreme_left_axis_x - 3*panel_spacingH)/4;
left_to_left_axis_gap4 = panel_width4 + panel_spacingH;


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



axis_title_font_size = 16;
default_font_size = 16;
%MarkerSize = 12;
default_linewidth = 1.15;
plot_linewidth = 2;




%now for the plots
axes('position', top_row.panel(1).posn);
auc = AUC.clarke2013;
drawBoxplot(auc, 'Clarke 2013');
%ylabel('AUC','fontsize',axis_title_font_size)
xlims = get(gca,'xlim')
ylims = get(gca,'ylim');
h = text(xlims(1)-1.3,...
    (ylims(1) + (ylims(2)-ylims(1))/2),...
    'AUC',...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center',...
   'fontsize',axis_title_font_size);
set(h,'rotation',90);

axes('position', top_row.panel(2).posn);
auc = AUC.yun2013sun;
drawBoxplot(auc, 'Yun 2013 - Sun');

axes('position', top_row.panel(3).posn);
auc = AUC.tatler2005;
drawBoxplot(auc, 'Tatler 2005');

axes('position', top_row.panel(4).posn);
auc = AUC.einhauser2008;
drawBoxplot(auc, 'Einhauser 2008');

axes('position', middle_row.panel(1).posn);
auc = AUC.tatler2007freeview;
drawBoxplot(auc, 'Tatler 2007 - Freeview');
%ylabel('AUC','fontsize',axis_title_font_size)
xlims = get(gca,'xlim')
ylims = get(gca,'ylim')
h = text(xlims(1)-(1.2*(top_row.panel(1).posn(3) / middle_row.panel(1).posn(3))),...
    (ylims(1) + (ylims(2)-ylims(1))/2),...
    'AUC',...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center',...
   'fontsize',axis_title_font_size);
set(h,'rotation',90);

axes('position', middle_row.panel(2).posn);
auc = AUC.judd2009;
drawBoxplot(auc, 'Judd 2009');

axes('position', middle_row.panel(3).posn);
auc = AUC.yun2013pascal;
drawBoxplot(auc, 'Yun 2013 - PASCAL');

axes('position', bottom_row.panel(1).posn);
auc = AUC.ehinger2009;
drawBoxplot(auc, 'Ehinger 2009');
%ylabel('AUC','fontsize',axis_title_font_size)
xlims = get(gca,'xlim')
ylims = get(gca,'ylim')
h = text(xlims(1)-(1.2*(top_row.panel(1).posn(3) / middle_row.panel(1).posn(3))),...
    (ylims(1) + (ylims(2)-ylims(1))/2),...
    'AUC',...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center',...
   'fontsize',axis_title_font_size);
set(h,'rotation',90);

axes('position', bottom_row.panel(2).posn);
auc = AUC.tatler2007search;
drawBoxplot(auc, 'Tatler 2007 - Search');

axes('position', bottom_row.panel(3).posn);
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

bh = boxplot(auc(:,[1 2 3 5 4]), {'isotropic', 'aspect ratio', 'experiment fitted', 'subject fitted', 'baseline'}, 'boxstyle', 'filled' , 'colors', 'k', 'symbol', 'k.', 'whisker', Inf);

ylim(1) = (floor(min(min(auc(:,1:5)))*100)/100); % - .001;
ylim(2) = (ceil(max(max(auc(:,1:5)))*100)/100); %+ .001;



set(bh(1,:),'linewidth',1.15);
set(bh(3,:),'linewidth',1.15); 
%set(h)
%h = findobj(gca,'Type','patch');

%fontSize = 12;

axis_title_font_size = 20;
default_font_size = 14;
smaller_font_size = 14;
%MarkerSize = 12;
default_linewidth = 1.15;
plot_linewidth = 2;


text_h = findobj(gca, 'Type', 'text');
tickLabelStr = {'isotropic', 'aspect ratio', 'exp. fitted', 'subj. fitted', 'baseline'};
    rotation = 45;
    
    for cnt = 1:length(text_h)
        set(text_h(cnt),    'FontSize', smaller_font_size,...
                            'Rotation', rotation, ...
                            'String', tickLabelStr{length(tickLabelStr)-cnt+1}, ...
                            'HorizontalAlignment', 'right')
    end
set(gca, 'fontsize', default_font_size,'TickDir','out','linewidth',default_linewidth)
set(gca,'XTick',[1:1:5])
%set(gca,'YLim',ylim,'YTick',[ylim(1):(ylim(2)-ylim(1))/2:ylim(2)])
%set(gca,'YLim',ylim,'YTick',[ylim(1):0.01:ylim(2)])
set(gca,'YLim',ylim) %,'YTick',[ylim(1):0.01:ylim(2)])

set(gca,'ticklength',2*get(gca,'ticklength'))
title(dataset, 'fontsize', axis_title_font_size)
end