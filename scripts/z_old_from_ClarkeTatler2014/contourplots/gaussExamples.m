clear all
close all
figure('position', [0 0 1000 500])

v = 0:0.1:1;

X = repmat(-1:0.01:1, [151,1]);
Y = repmat(-0.75:0.01:0.75, [201, 1])';
sigma = 0.261;


subplot(1,3,1)
nu = 1;
D =  mvnpdf([X(:) Y(:)], [0 0], [sigma, 0; 0, nu*sigma]);
D = reshape(D, [151 201]);
D = D./max(D(:));
contour(D,v)
axis equal
axis([1 201 1 151])
set(gca,'XTickLabel','');
set(gca,'YTickLabel','')
xlabel('$\nu=1.00$', 'Interpreter','LaTex');

subplot(1,3,2)
nu = 0.75;
D =  mvnpdf([X(:) Y(:)], [0 0], [sigma, 0; 0, nu*sigma]);
D = reshape(D, [151 201]);
D = D./max(D(:));
contour(D,v)
axis equal
axis([1 201 1 151])
set(gca,'XTickLabel','');
set(gca,'YTickLabel','')
xlabel('$\nu=0.75$', 'Interpreter','LaTex');
subplot(1,3,3)
nu = 0.45;
D =  mvnpdf([X(:) Y(:)], [0 0], [sigma, 0; 0, nu*sigma]);
D = reshape(D, [151 201]);
D = D./max(D(:));
contour(D,v)
axis equal
axis([1 201 1 151])
set(gca,'XTickLabel','');
set(gca,'YTickLabel','')
xlabel('$\nu=0.45$', 'Interpreter','LaTex');

set(gcf, 'Color', 'w');
export_fig gaussExamples.pdf