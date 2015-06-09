
%plotting stuff
axis_title_font_size = 20;
default_font_size = 16;
default_linewidth = 1.15;
plot_linewidth = 3;
plot_linewidth2 = 1;


load smallNSim

figure('position', [0 0 1000 600])

subplot(1,2,1);
fitAUC(:,:) = mean(mean(AUC.judd2009.fit,2),3);
plot(nanmean(fitAUC,2), 'k-', 'linewidth', plot_linewidth);
hold all
bslAUC(:,:) = mean(mean(AUC.judd2009.bl,2),3);
plot(nanmean(bslAUC,2), 'k--', 'linewidth', plot_linewidth);
title('Judd 2009', 'fontsize', axis_title_font_size)
xlabel('Number of Trials', 'fontsize', axis_title_font_size)
ylabel('AUC', 'fontsize', axis_title_font_size)
set(gca,'linewidth',default_linewidth,'TickDir','out','fontsize',default_font_size)


clear fitAUC bslAUC
subplot(1,2,2);
fitAUC(:,:) = nanmean(nanmean(AUC.clarke2013.fit,2),3);
plot(nanmean(fitAUC,2), 'k-', 'linewidth', plot_linewidth);
hold all
bslAUC(:,:) = nanmean(nanmean(AUC.clarke2013.bl,2),3);
plot(nanmean(bslAUC,2), 'k--', 'linewidth', plot_linewidth);
title('Yun 2014', 'fontsize', axis_title_font_size)
xlabel('Number of Trials', 'fontsize', axis_title_font_size)
title('Clarke 2013', 'fontsize', axis_title_font_size); 
set(gca,'linewidth',default_linewidth,'TickDir','out','fontsize',default_font_size)


set(gcf, 'Color', 'w');
export_fig smallNsim.pdf

clear fitAUC bslAUC