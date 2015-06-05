function plotHeatmap(fix)


qX = 80;
qY = 60;
imagesc(hist3(fix, [qX, qY])')
axis equal
axis xy
axis off