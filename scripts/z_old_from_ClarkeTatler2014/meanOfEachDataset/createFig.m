% do everything script
clear all;
close all

addpath('../helperFunctions/')

nRep = 1;
Sig2 = 0.22;

axis_title_font_size = 24;
default_font_size = 18;
MarkerSize = 12;
default_linewidth = 1.15;
marker_linewidth = 1.15;


figure('position', [0 0 1000 500]);

subplot(1,3,1:2)
fix = grabFixations('Clarke2013');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)
hold on
fix = grabFixations('Yun2013SUN');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Tatler2005');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Einhauser2008');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Tatler2007freeview');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Judd2009');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Yun2013PASCAL');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Ehinger2009TA');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Tatler2007searchTA');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Asher2013TA');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

plot([0 0 ],[-1 1], 'k--')
plot([-1 1],[0 0 ], 'k--')
axis equal
axis([-1 1 -.75 .75])

xlabel('x (normalised)', 'fontsize', axis_title_font_size)
ylabel('y (normalised with respect to x)', 'fontsize', axis_title_font_size)
set(gca,'XTick',-1:0.25:1)
set(gca,'YTick',-1:0.25:1)
set(gca,'fontsize',default_font_size,'TickDir','out','linewidth',default_linewidth)

subplot(1,3,3)
fix = grabFixations('Clarke2013');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)
hold on
fix = grabFixations('Yun2013SUN');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Tatler2005');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Einhauser2008');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Tatler2007freeview');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Judd2009');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Yun2013PASCAL');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Ehinger2009TA');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Tatler2007searchTA');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

fix = grabFixations('Asher2013TA');
plot(mean(fix(:,3)), mean(fix(:,4)), 'xk', 'MarkerSize', MarkerSize,'linewidth',marker_linewidth)

plot([0 0 ],[-1 1], 'k--')
xlabel('x (normalised)', 'fontsize', axis_title_font_size-4)
ylabel('y (normalised with respect to x)', 'fontsize', axis_title_font_size-4)

set(gca,'XTick',-.1:0.05:.1)
set(gca,'YTick',-.1:0.05:.1,'YAxisLocation','right')
set(gca,'fontsize',default_font_size-2,'TickDir','out','linewidth',default_linewidth)
plot([-1 1],[0 0 ], 'k--')
axis equal
axis([-.1 .1 -.1 .1])

set(gcf, 'Color', 'w');
export_fig distOfMeanFix.pdf
