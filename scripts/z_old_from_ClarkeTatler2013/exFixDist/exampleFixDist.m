clear all
close all
addpath('../helperFunctions/')
figure('position', [0 0 800 300]);
fix = grabFixations('Judd2009');
subplot(1,4,1);
hist(fix(:,3), -0.951:0.1:0.95);
axis([-1 1 0 6000]);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[.2 .2 .2],'EdgeColor','k')
xlabel('x')
ylabel('frequency');
subplot(1,4,2);
hist(fix(:,4), -0.951:0.1:0.95);
axis([-1 1 0 9000]);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[.2 .2 .2],'EdgeColor','k')
xlabel('y');
set(gcf, 'Color', 'w');

subplot(1,4,3:4);
 smoothhist2D(fix(:,3:4),15, [256 0.75*256], 1000, 'contour')
csvwrite('juddFix.txt', fix(:,3:4));
 colormap gray
axis equal
axis([1 256 1 0.75*256])
 set(gca, 'xTick', nan)
 set(gca, 'yTick', nan)
 hold all
 plot([0 256], [0.75*128 0.75*128], 'k:')
  plot([128 128],[0, 256], 'k:')
  xlabel('x'); ylabel('y');
export_fig fixDist.pdf