%function alternative_judd_FixDist_plot

clear all
close all


R = dlmread('../../data/Judd2009/DatabaseCode/juddFixData_TrialSubjFixNXY.txt');
% remove NaNs
R(R(:,4)<(-R(:,6)/2),:) = [];
R(R(:,5)<(-R(:,7)/2),:) = [];
R(R(:,4)>(R(:,6)/2),:) = [];
R(R(:,5)>(R(:,7)/2),:) = [];

R(isnan(R(:,4)),:) = [];
R(isnan(R(:,5)),:) = [];

R(:,4) = R(:,4) + R(:,6)/2;
R(:,5) = R(:,5) + R(:,7)/2;

% centre of image should = [0,0], and transform to a square of width 2

% get fixations from most common aspect ratio only
idx = find(~((R(:,6)==1024).*(R(:,7)==768)));
R(idx,:) = [];


trs = R(:,1);
R(:,[1 6 7]) = [];

% remove initial fixation
if ~isempty(trs)
trs(R(:,2)==1,:) = [];
end
R(R(:,2)==1,:) = [];


fix = R;

%remove offscreen fixations
fix(round(fix(:,3)) <= 0,:) = [];
fix(round(fix(:,4)) <= 0,:) = [];

fix(round(fix(:,3)) > 1024,:) = [];
fix(round(fix(:,4)) > 768,:) = [];

fwhm_deg = 1
pix_per_deg = 35
screen_height_pix = 768
screen_width_pix = 1024

%gaussian mask
standard_dev = fwhm_deg/2.35482;
standard_dev_pix = standard_dev*pix_per_deg;
params = [0,0,standard_dev_pix^2,1];
patch_size = round(sqrt(params(3)))*6;
%NEED TO PAD THEN TRIM THE ARRAYS FOR PDISTS TO AVOID ISSUES AT EDGES...
pad_size = round(patch_size/2)*2;
offset_to_correct_for_padding = pad_size/2;

pdist = zeros(screen_height_pix+pad_size,screen_width_pix+pad_size);

%make gaussian
patch_size = round(sqrt(params(3)))*6;
%[X,Y]=meshgrid([-50:1:50]);
[X,Y]=meshgrid([-round(patch_size/2):1:round(patch_size/2)]);
% [output]=gaussian2d([0 0 50 1],X,Y);
cx			=params(1);
cy			=params(2);
gauss_var	=params(3);
gauss_mag	=params(4);
%this allows you to customise the center location of the gabor
x=X-cx;
y=Y-cy;
%output=exp(-0.5* ((x.^2 + y.^2) / (2*gauss_var) ));
gaussian_mask=exp(- ((x.^2 + y.^2) / (2*gauss_var) ));
gaussian_mask=gaussian_mask*gauss_mag;


LEs = round(fix(:,3)) - round(patch_size/2) + offset_to_correct_for_padding;
TEs = round(fix(:,4)) - round(patch_size/2) + offset_to_correct_for_padding;

for count = 1:size(TEs,1)
pdist(TEs(count):TEs(count)+round(patch_size),LEs(count):LEs(count)+round(patch_size)) =...
    pdist(TEs(count):TEs(count)+round(patch_size),LEs(count):LEs(count)+round(patch_size)) + (gaussian_mask);
end

pdist_trimmed = pdist(offset_to_correct_for_padding+1:end-offset_to_correct_for_padding,offset_to_correct_for_padding+1:end-offset_to_correct_for_padding);

[c,h] = contourf(pdist_trimmed,9);
%set(h,'ShowText','on','TextStep',get(h,'LevelStep'))
set(h,'linewidth',1.5)


axis_title_font_size = 18;
default_font_size = 14;
%plot
figure('position', [0 0 800 300]);
subplot(1,4,1);
hist(fix(:,3),20);
axis([1 1024 0 6000]);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[.2 .2 .2],'EdgeColor','k')
set(gca,'fontsize',default_font_size,'XTick',[1,1024/2,1024],'TickDir','out')
xlabel('x','fontsize',axis_title_font_size)
ylabel('Frequency','fontsize',axis_title_font_size);
subplot(1,4,2);
hist(fix(:,4),20);
axis([1 768 0 7000]);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[.2 .2 .2],'EdgeColor','k')
xlabel('y','fontsize',axis_title_font_size);
set(gca,'fontsize',default_font_size,'XTick',[1,768/2,768],'TickDir','out')

subplot(1,4,3:4)
[c,h] = contourf(pdist_trimmed,9);
%set(h,'ShowText','on','TextStep',get(h,'LevelStep'))
limited_gray = (gray*(2/3)) + (1/3);
colormap(limited_gray)
set(h,'linewidth',1.15)
xlabel('x','fontsize',axis_title_font_size)
ylabel('y','fontsize',axis_title_font_size);
set(gca,'fontsize',default_font_size,'XTick',[1,1024/2,1024],'yTick',[1,768/2,768],'YAxisLocation','right','TickDir','out')
axis image
axis ij

set(gcf, 'Color', 'w');

%print -painters -dpdf -r600 test.pdf
export_fig fixDist.pdf