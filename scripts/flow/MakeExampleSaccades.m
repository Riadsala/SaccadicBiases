
%%centre
h=figure
set(gca, 'Position', get(gca, 'OuterPosition') - ...
     get(gca, 'TightInset') * [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]);
cent=getFlowMap(0,0);
colormap 'hot'
truesize
hold on
scatter(205/2,155/2,300,'black','filled')

saveas(h, 'PredictionMaps/Center.png');

right=getFlowMap(-0.5,0.75/2);
colormap 'hot'
hold on
scatter(205/2-(205/4),(155/4),300,'black','filled')
set(gca, 'Position', get(gca, 'OuterPosition') - ...
     get(gca, 'TightInset') * [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]);
saveas(h, 'PredictionMaps/UpRight.png');

right=getFlowMap(0.5,(-0.75/2));
colormap 'hot'
hold on
scatter(205/2+(205/4),((155/4)*3),300,'black','filled')
set(gca, 'Position', get(gca, 'OuterPosition') - ...
     get(gca, 'TightInset') * [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0]);
saveas(h, 'PredictionMaps/DownLeft.png');