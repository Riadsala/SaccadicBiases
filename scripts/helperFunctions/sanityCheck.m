%%sanity check x-y- distributions of data
function []=sanityCheck(dataset)

%%grab fixations for that dataset
fix=grabFixations(dataset);

%%for the distributions - leave in ones outside the scene edges
%%plot x distribution
subplot(3,2,1)
hist(fix.x,20)
title('x distribution')

%%plot y distribution
subplot(3,2,2)
hist(fix.y,20)
title('y distribution')



% Estimate a continuous pdf from the discrete data
%%just subset cases where x>-1 and x<1
x=fix.x(find(fix.x<1 & fix.x>-1));
y=fix.y(find(fix.y<0.75 & fix.y>-0.75));
[pdfx xi]= ksdensity(x);
[pdfy yi]= ksdensity(y);
% Create 2-d grid of coordinates and function values, suitable for 3-d plotting
[xxi,yyi]     = meshgrid(xi,yi);
[pdfxx,pdfyy] = meshgrid(pdfx,pdfy);
% Calculate combined pdf, under assumption of independence
pdfxy = pdfxx.*pdfyy; 
% Plot the results
subplot(3,2,3)
imagesc(pdfxy)
colormap('hot')
title('fixation plot')

subplot(3,2,4)
mesh(xxi,yyi,pdfxy)
colormap('hot')
set(gca,'XLim',[-1 1])
set(gca,'YLim',[-0.75 0.75])
title('fixation surface plot')




%%calculate saccade amplitudes
saccs = convertFixToSacc(fix);
saccs(:,6)=sqrt(((saccs(:,2)-saccs(:,4)).^2)+((saccs(:,3)-saccs(:,5)).^2));
%%plot saccade amplitude dsitributions
subplot(3,2,5)
hist(saccs(:,6))
title('saccade amplitude distribution')


%%plot saccade amplitudes by index but only do up to when there are 10
%%saccades (to avoid stupid error bars)

%calculate frequencies of saccade index
tbl = tabulate(saccs(:,1))
%find times where there are less than 10 saccades
remrefs=find(tbl(:,2)<10)
%make subset of data with only these cases
saccs2=saccs(saccs(:,1)<remrefs(1),:);
%plot sac amps across fixation index
subplot(3,2,6)
grpstats(saccs2(:,6),saccs2(:,1),0.05)
title('saccade amplitude with fixation index')


end