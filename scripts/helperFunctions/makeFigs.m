%%Run all sanity check and export images

datasets = {
    'Asher2013',...
    'Clarke2013', ...
    'Einhauser2008', ...
    'Tatler2005', ...
    'Tatler2007freeview', ...
    'Tatler2007search', ...
    'Judd2009',...
    'Yun2013SUN',...
    'Yun2013PASCAL',...
    'Clarke2009'}




for i = 1:size(datasets,2)
    
dataset=char(datasets(i))
%%grab fixations for that dataset
fix=grabFixations(dataset);

%%for the distributions - leave in ones outside the scene edges
%%plot x distribution
%subplot(3,2,1)


%%calculate saccade amplitudes
if strcmp(dataset, 'Asher2013')
    aspRat= 0.8;
else
    aspRat = 0.75;
end

saccs = convertFixToSacc(fix, aspRat);
saccs(:,6)=sqrt(((saccs(:,2)-saccs(:,4)).^2)+((saccs(:,3)-saccs(:,5)).^2));

%%plot saccade amplitude dsitributions

%%plot saccade amplitudes by index but only do up to when there are 10
%%saccades (to avoid stupid error bars)

%calculate frequencies of saccade index
tbl = tabulate(saccs(:,1))
%find times where there are less than 10 saccades
remrefs=find(tbl(:,2)<10)
%make subset of data with only these cases
saccs2=saccs(saccs(:,1)<remrefs(1),:);
%plot sac amps across fixation index
%subplot(3,2,6)


% Estimate a continuous pdf from the discrete data
%%just subset cases where x>-1 and x<1

saccs3=saccs(saccs(:,1)~=1,:);
x=saccs3(find(saccs3(:,2)<1 & saccs3(:,2)>-1),2);
y=saccs3(find(saccs3(:,3)<0.75 & saccs3(:,3)>-0.75),3);
sacamps=saccs2(find(saccs2(:,2)<1 & saccs2(:,2)>-1 & saccs2(:,3)<0.75 & saccs2(:,3)>-0.75 & saccs2(:,4)<1 & saccs2(:,4)>-1 & saccs2(:,5)<0.75 & saccs2(:,5)>-0.75),6)
sacindex=saccs2(find(saccs2(:,2)<1 & saccs2(:,2)>-1 & saccs2(:,3)<0.75 & saccs2(:,3)>-0.75 & saccs2(:,4)<1 & saccs2(:,4)>-1 & saccs2(:,5)<0.75 & saccs2(:,5)>-0.75),1)
clear saccs3







%%go to figs
cd ..
cd ..
cd data
cd SanityCheckReport
cd Figs


hist(x,20)
title('x distribution')
name=[dataset,'_xdist.png'];
saveas(gcf,name)


hist(y,20)
title('y distribution')
name=[dataset,'_ydist.png'];
saveas(gcf,name)


grpstats(sacamps,sacindex,0.05)
title('saccade amplitude with fixation index')
name=[dataset,'_sacampindex.png'];
saveas(gcf,name)

hist(sacamps)
title('saccade amplitude distribution')
name=[dataset,'_sacampdist.png'];
saveas(gcf,name)


[pdfx xi]= ksdensity(x);
[pdfy yi]= ksdensity(y);
% Create 2-d grid of coordinates and function values, suitable for 3-d plotting
[xxi,yyi]     = meshgrid(xi,yi);
[pdfxx,pdfyy] = meshgrid(pdfx,pdfy);
% Calculate combined pdf, under assumption of independence
pdfxy = pdfxx.*pdfyy; 
% Plot the results
%subplot(3,2,3)
imagesc(pdfxy)
colormap('hot')
title('fixation plot')
name=[dataset,'_heat.png'];
saveas(gcf,name)

%subplot(3,2,4)
mesh(xxi,yyi,pdfxy)
colormap('hot')
set(gca,'XLim',[-1 1])
set(gca,'YLim',[-0.75 0.75])
title('fixation surface plot')
name=[dataset,'_3D.png'];
saveas(gcf,name)

cd ..
cd ..
cd ..
cd scripts
cd helperFunctions

end

