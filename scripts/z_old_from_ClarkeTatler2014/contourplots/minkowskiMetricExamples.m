clear all
close all

X = repmat(-1:0.01:1, [151,1]);
Y = repmat(-0.75:0.01:0.75, [201, 1])';
v = 0:0.2:2;
subplot(2,2,1)
Z = pdist2([X(:), Y(:)], [0 0], 'minkowski', 1);
Z =  reshape(Z, [151, 201]);
contour(Z,v);
title('m=1 (Manhatten distance)');
set(gca,'XTickLabel','');
set(gca,'YTickLabel','')


subplot(2,2,2)
Z = pdist2([X(:), Y(:)], [0 0], 'minkowski', 1.5);
Z =  reshape(Z, [151, 201]);
contour(Z,v);
title('m=1.5');
set(gca,'XTickLabel','');
set(gca,'YTickLabel','')


subplot(2,2,3)
Z = pdist2([X(:), Y(:)], [0 0], 'minkowski', 2);
Z =  reshape(Z, [151, 201]);
contour(Z,v);
title('m=2 (Euclidean distance)');
set(gca,'XTickLabel','');
set(gca,'YTickLabel','')


subplot(2,2,4)
Z = pdist2([X(:), Y(:)], [0 0], 'minkowski', 3);
Z =  reshape(Z, [151, 201]);
contour(Z,v);
title('m=3 ');
set(gca,'XTickLabel','');
set(gca,'YTickLabel','')

set(gcf, 'Color', 'w');
export_fig minkowskiMetricExamples.pdf