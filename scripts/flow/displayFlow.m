clear all
close all

addpath('../helperfunctions');

fix = grabFixations('Clarke2013');
saccs = convertFixToSacc(fix);
dlmwrite('clarke2013saccs.txt', saccs);


% now plot heatmaps of sacc end points binned by sacc start point
qX = 4; 
qY = 3;
saccs(:,1) = ceil(qX*(saccs(:,1)/2+0.5));
saccs(:,2) = ceil(qY*(saccs(:,2)/2+0.5));
saccs(saccs(:,1)==0,1)=1;
saccs(saccs(:,2)==0,2)=1;

spctr = 0;
for i = qY:-1:1
    for j = 1:qX
        spctr = spctr + 1;
        idx = find((saccs(:,1)==j).*(saccs(:,2)==i));
        qFix = saccs(idx,3:4);
        subplot(qY, qX, spctr);
        plotHeatmap(qFix);
        clear idx qFix
    end
end




